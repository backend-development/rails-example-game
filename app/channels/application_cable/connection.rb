module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_devise_user
      logger.add_tags 'ActionCable', current_user
    end

    protected

    def find_devise_user
      env['warden'].user
    end
  end
end
