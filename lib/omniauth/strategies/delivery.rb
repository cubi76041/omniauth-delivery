require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Delivery < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "global"
      PRODUCTION_USER_SITE = 'https://laundryapi.delivery.com'
      PRODUCTION_API_SITE = 'https://api.delivery.com' 
      DEVELOPMENT_USER_SITE = 'http://laundryqa.delivery.com'
      DEVELOPMENT_API_SITE = 'http://sandbox.delivery.com'
      @@mode = :production
      
      option :client_options, {
        :site => PRODUCTION_API_SITE,
        :authorize_url => '/third_party/authorize',
        :token_url => '/third_party/access_token'
      }
      
      option :authorize_options, [:development]
      
      uid { raw_info['usersid'] }
      
      info do
        {
          :first_name => raw_info['first_name'], 
          :last_name  => raw_info['last_name'],
          :name => raw_info['first_name'].to_s + ' ' + raw_info['last_name'].to_s,
          :email => raw_info['email'],
          :addresses => raw_info['addresses'],
        }
      end
      
      extra do
        { :raw_info => raw_info }
      end

      def request_phase
        @@mode = :development if authorize_params.include?(:development)
        options[:authorize_options].delete(:development)
        options[:client_options][:site] = @@mode == :development ? DEVELOPMENT_API_SITE : PRODUCTION_API_SITE
        options[:authorize_params] = client_params.merge(options[:authorize_params])
        super
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, client_params.merge({
          :grant_type => 'authorization_code'}))
      end
      
      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = :token
        user_site = @@mode == :development ? DEVELOPMENT_USER_SITE : PROUCTION_USER_SITE
        @raw_info ||= access_token.post(user_site + '/api/v1/customer/auth').parsed
      end
      
      private
      
      def client_params
        {:client_id => options[:client_id], :redirect_uri => callback_url ,:response_type => "code", :scope => DEFAULT_SCOPE}
      end
    end
  end
end
