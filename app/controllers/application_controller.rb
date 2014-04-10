# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  # CSRF脆弱性の対策のため、サインアウトさせる。
  def handle_univerified_request
    sign_out
    super
  end

end
