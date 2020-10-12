class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    # rules of play
  end
end

# What would happen if we added a play method to the Bingo class.

  # If we added instance method definition for a method called play to the 
  # Bingo class. The Bingo#play method would override the Game#play method.
  # If we wated to retain some of the fucntionality of the #play method from
  # the super class. We could call it from withing the new Bingo#play definition
  # using the super keyword.
