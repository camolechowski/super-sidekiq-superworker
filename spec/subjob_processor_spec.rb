require 'spec_helper'

describe Sidekiq::Superworker::SubjobProcessor do
  before :each do
    Sidekiq.redis { |conn| conn.flushdb }
  end

  let(:redis) { Sidekiq.redis { |r| r } }

  let(:subjob_attributes) do
    {
      subjob_id: "456",
      superjob_id: "8910",
      :parent_id => "1",
      :children_ids => [],
      :subworker_class => "Subworker",
      :superworker_class => "Superworker",
      :arg_keys => [:a, :b],
      :arg_values => [:c, :d],
      :status => "queued",
      :descendants_are_complete => false,
      :meta => nil
    }
  end

  let(:parent_parallel_subjob_attributes) do
    {
      :subjob_id => "1",
      :superjob_id => "8910",
      :children_ids => ["456"],
      :subworker_class => "parallel",
      :superworker_class => "Superworker",
      :arg_keys => [:a, :b],
      :arg_values => [:c, :d],
      :status => "queued",
      :descendants_are_complete => false,
      :meta => nil
    }
  end

  let(:child_subjob) { Sidekiq::Superworker::Subjob.create(subjob_attributes) }
  let(:parent_parallel_subjob) { Sidekiq::Superworker::Subjob.create(parent_parallel_subjob_attributes) }

  describe "deleting subjobs on completion" do
    before do
      Sidekiq::Superworker.options[:delete_subjobs_after_superjob_completes] = delete_after_complete
    end

    after do
      Sidekiq::Superworker.options[:delete_subjobs_after_superjob_completes] = false
    end

    context "when delete_subjobs_after_superjob_completes is true" do
      let(:delete_after_complete) { true }

      it "should not leave the parallel subjob around in redis on completion" do
        expect(redis.exists?(parent_parallel_subjob.key)).to be_truthy
        expect(redis.exists?(child_subjob.key)).to be_truthy

        described_class.complete(child_subjob)

        expect(redis.exists?(child_subjob.key)).to be_falsey
        expect(redis.exists?(parent_parallel_subjob.key)).to be_falsey
      end
    end

    context "when delete_subjobs_after_superjob_completes is false" do
      let(:delete_after_complete) { false }

      it "should leave both subjobs in redis" do
        expect(redis.exists?(parent_parallel_subjob.key)).to be_truthy
        expect(redis.exists?(child_subjob.key)).to be_truthy

        described_class.complete(child_subjob)

        expect(redis.exists?(parent_parallel_subjob.key)).to be_truthy
        expect(redis.exists?(child_subjob.key)).to be_truthy
      end
    end
  end
end
