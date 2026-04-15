# frozen_string_literal: true

module DomniqWebPage
  class DataFetcher
    def self.fetch(config)
      data = {}

      contributors_days  = (config.dig("hero", "contributors_days") || 30).to_i
      contributors_count = (config.dig("hero", "contributors_count") || 10).to_i
      contributors_on    = config.dig("hero", "contributors_enabled")
      leaderboard_on     = config.dig("leaderboard", "leaderboard_enabled")
      topics_on          = config.dig("topics", "topics_enabled")
      topics_count       = (config.dig("topics", "topics_count") || 5).to_i

      data[:contributors] = begin
        if contributors_on || leaderboard_on
          User
            .joins(:posts)
            .includes(:user_profile, :user_stat)
            .where(posts: { created_at: contributors_days.days.ago.. })
            .where.not(username: %w[system discobot])
            .where(active: true, staged: false)
            .group("users.id")
            .order("COUNT(posts.id) DESC")
            .limit(contributors_count)
            .select("users.*, COUNT(posts.id) AS post_count")
        end
      rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotFound, NoMethodError => e
        Rails.logger.warn("[DWP] contributors fetch failed: #{e.message}")
        nil
      end

      data[:topics] = begin
        if topics_on
          Topic
            .listable_topics
            .where(visible: true)
            .where("topics.created_at > ?", 30.days.ago)
            .order(posts_count: :desc)
            .limit(topics_count)
            .includes(:category, :user)
        end
      rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotFound, NoMethodError => e
        Rails.logger.warn("[DWP] topics fetch failed: #{e.message}")
        nil
      end

      chat_count = 0
      begin
        chat_count = Chat::Message.count if defined?(Chat::Message)
      rescue ActiveRecord::StatementInvalid
        chat_count = 0
      end

      data[:stats] = begin
        {
          members: User.real.count,
          topics:  Topic.listable_topics.count,
          posts:   Post.where(user_deleted: false).count,
          likes:   Post.sum(:like_count),
          chats:   chat_count,
        }
      rescue ActiveRecord::StatementInvalid, NoMethodError => e
        Rails.logger.warn("[DWP] stats fetch failed: #{e.message}")
        { members: 0, topics: 0, posts: 0, likes: 0, chats: 0 }
      end

      data
    end
  end
end
