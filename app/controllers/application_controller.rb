# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :init_cache_service

  def init_cache_service
    @cache_service = ::Http::Cache::CacheService.new
  end
end
