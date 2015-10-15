class Api::V1::LanguagesController < Api::V1::BaseApiController

  include LanguagesDoc

  def classify
    wl = WhatLanguage.new(:english, :german, :french, :spanish, :portuguese)
    if params[:text].blank?
      render_parameters_missing
    else
      @language = wl.language(params[:text].to_s)
      render_success 'language', @language
    end
  end
end
