require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Delivery < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "global"
      option :client_options, {
        :site => 'http://sandbox.delivery.com',
        :authorize_url => '/third_party/authorize',
        :token_url => '/third_party/access_token'
      }
      
      uid { raw_info['usersid'] }
      
      info do
        {
          :first_name => raw_info['firstName'], 
          :last_name  => raw_info['lastName'],
          :email => raw_info['email'],
          :name => raw_info['firstName'].to_s + ' ' + raw_info['lastName'].to_s,
          :addresses => raw_info['addresses'],
          :phone => raw_info['phoneNumber']['number'],
        }
      end
      
      extra do
        { :raw_info => raw_info }
      end

      def request_phase
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
        @raw_info ||= access_token.post('http://laundryqa.delivery.com/api/v1/customer/auth').parsed
      end
      
      private
      
      def client_params
        {:client_id => options[:client_id], :redirect_uri => callback_url ,:response_type => "code", :scope => DEFAULT_SCOPE}
      end
    end
  end
end
