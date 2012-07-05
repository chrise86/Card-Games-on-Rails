class Room < ActiveRecord::Base
  
    GAMES = ["hearts", "spades"]

    before_destroy :clear_users_room_ids
    after_create :create_game
    
    has_many :games
    
    validates_presence_of :game_type
    validates_inclusion_of :game_type, :in => GAMES

    attr_accessible :game_type, :size

    
    def game
      self.games.first
    end
    
    private

    def clear_users_room_ids
      self.users.each {|user| update_attributes(:room_id => nil)}
    end
    
    def create_game
      if game_type == "hearts"
        HeartsGame.create(:room_id => self.id, :size => 4)
      elsif game_type == "spades"
        SpadesGame.create(:room_id => self.id, :size => 4)
      end
      update_size
    end
    
    def update_size
      self.size = self.games.first.size
      self.save
    end

  end
