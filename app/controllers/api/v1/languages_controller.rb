class Api::V1::LanguagesController < Api::V1::BaseApiController

  include LanguagesDoc

  def classify
    wl = WhatLanguage.new(:english, :german, :french, :spanish, :portuguese)
    if params[:text].blank?
      render_parameters_missing
    else
      text = self.normalize(params[:text].to_s)
      @language = wl.language(text)
      render_success 'language', @language
    end
  end

  protected

  # @expose
  def normalize(text)
    text.downcase.gsub(/[àáãâ]/, 'a').gsub(/[èéẽê]/, 'e').gsub(/[íìĩî]/, 'i').gsub(/[óòõô]/, 'o').gsub(/[úùũû]/, 'u').gsub('ç', 'c')
  end
end
