class Api::V1::LanguagesController < Api::V1::BaseApiController

  include LanguagesDoc

  def classify
    wl = WhatLanguage.new(:english, :german, :french, :spanish, :portuguese)
    @language = wl.language('this is a test')
    if params[:text].blank?
      render_parameters_missing
    else
      render_success 'language', @language
    end
  end
end
