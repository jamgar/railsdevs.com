module Developers
  class Meta
    private attr_reader :query

    def initialize(query)
      @query = query
    end

    def title
      components = []

      # i18n-tasks-use t("developers.meta.hire")
      components << i18n("hire")

      components << role_level if role_level

      # i18n-tasks-use t("developers.meta.freelance")
      components << i18n("freelance") if freelance?

      # i18n-tasks-use t("developers.meta.ruby_on_rails_developers")
      components << i18n("ruby_on_rails_developers")

      # i18n-tasks-use t("developers.meta.in_country")
      components << i18n("in_country", country:) if country

      components.join(" ")
    end

    def description
      # i18n-tasks-use t("developers.meta.description")
      i18n("description", developers_count:)
    end

    private

    def i18n(key, options = {})
      I18n.t(key, **options.merge(scope: "developers.meta"))
    end

    def role_level
      if query.role_levels.one?
        role = query.role_levels.first
        scope = [:activerecord, :attributes, :role_level]
        I18n.t(role, scope:, default: role.to_s.humanize).downcase
      end
    end

    def freelance?
      query.role_types.include?(:part_time_contract) &&
        query.role_types.include?(:full_time_contract) &&
        !query.role_types.include?(:full_time_employment)
    end

    def country
      if query.countries.one?
        query.countries.first
      end
    end

    def developers_count
      @developers_count ||= Developer.count.round(-1)
    end
  end
end
