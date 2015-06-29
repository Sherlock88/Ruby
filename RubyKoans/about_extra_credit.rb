# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

##============================================================================##
 
=begin

= Playing Greed

Greed is a dice game played among 2 or more players, using 5
six-sided dice.

== Playing Greed

Each player takes a turn consisting of one or more rolls of the dice.
On the first roll of the game, a player rolls all five dice which are
scored according to the following:

  Three 1's => 1000 points
  Three 6's =>  600 points
  Three 5's =>  500 points
  Three 4's =>  400 points
  Three 3's =>  300 points
  Three 2's =>  200 points
  One   1   =>  100 points
  One   5   =>   50 points

A single die can only be counted once in each roll.  For example,
a "5" can only count as part of a triplet (contributing to the 500
points) or as a single 50 points, but not both in the same roll.

Example Scoring

   Throw       Score
   ---------   ------------------
   5 1 3 4 1   50 + 2 * 100 = 250
   1 1 1 3 1   1000 + 100 = 1100
   2 4 4 5 4   400 + 50 = 450

The dice not contributing to the score are called the non-scoring
dice.  "3" and "4" are non-scoring dice in the first example.  "3" is
a non-scoring die in the second, and "2" is a non-score die in the
final example.

After a player rolls and the score is calculated, the scoring dice are
removed and the player has the option of rolling again using only the
non-scoring dice. If all of the thrown dice are scoring, then the
player may roll all 5 dice in the next roll.

The player may continue to roll as long as each roll scores points. If
a roll has zero points, then the player loses not only their turn, but
also accumulated score for that turn. If a player decides to stop
rolling before rolling a zero-point roll, then the accumulated points
for the turn is added to his total score.

== Getting "In The Game"

Before a player is allowed to accumulate points, they must get at
least 300 points in a single turn. Once they have achieved 300 points
in a single turn, the points earned in that turn and each following
turn will be counted toward their total score.

== End Game

Once a player reaches 3000 (or more) points, the game enters the final
round where each of the other players gets one more turn. The winner
is the player with the highest score after the final round.

== References

Greed is described on Wikipedia at
http://en.wikipedia.org/wiki/Greed_(dice_game), however the rules are
a bit different from the rules given here.

=end

##============================================================================##

 class DiceSet
   
   attr_reader :rolls

   ##============================================================================##
   
   def roll(x)
     @rolls = []
     x.times {@rolls << (1 + rand(6))}
     @rolls
   end

   ##============================================================================##
   
   def values
     @rolls
   end

   ##============================================================================##
   
   def score(dice)
     face_counts = [0,0,0,0,0,0]
     score = 0
     dice_count = dice.size
     scoring_dice_count = 0
     faces = [2,3,4,5,6]
     
     # Count the faces
     dice.each do |x|
         face_counts[x-1] += 1
     end
  
     # Three 1's  = 1000 is a special case
     if face_counts[0] >= 3
       score += 1000
       face_counts[0] -= 3
       scoring_dice_count += 3
     end
  
     # Single 1 = 100
     if face_counts[0] > 0
       score += face_counts[0] * 100
       scoring_dice_count += face_counts[0]
     end
  
     # Three of any face(x) but 1 = 100x
     faces.each do |x|
       if face_counts[x-1] >= 3
         score += x * 100
         face_counts[x-1] -= 3
         scoring_dice_count += 3
       end
     end
    
     # Single 5 = 50
     if face_counts[4] > 0
       score += 50 * face_counts[4]
       scoring_dice_count += face_counts[4]
     end
  
     non_scoring_dice_count = dice_count - scoring_dice_count
     return [score, non_scoring_dice_count]
   end
 
 end
 
 ##============================================================================##
 
 class Player
   
   attr_accessor :player_score
   attr_reader :diceSet
   
   ##============================================================================##
   
   def initialize
     @player_score = 0
     @diceSet = DiceSet.new
   end
   
   ##============================================================================##
   
   def throw_dice(dice_count)
     dice_roll = @diceSet.roll dice_count
     player_score_throw, non_scoring_dice_count = @diceSet.score dice_roll
     puts "\nThrow: #{dice_roll}"
     puts "Throw score: #{player_score_throw}"
     puts "Non scoring dice count: #{non_scoring_dice_count}"
     return player_score_throw, non_scoring_dice_count
   end
     
 end
 
 ##============================================================================##
 
 class Game
   
   attr_reader :players_scores
   
   ##============================================================================##
    
   def initialize(player_count)
     @player_count = player_count
     @game_players = Array.new
     @players_scores = Array.new
     @final_round = false
     @final_round_turn_count = 0
     player_count.times { @game_players << Player.new }
     player_count.times { @players_scores << 0 }
   end
   
   ##============================================================================##
 
   def roll_until_zero_point_or_player_decides_to_stop_rolling(player, player_score_turn, choice, non_scoring_dice_count)
     while non_scoring_dice_count > 0 && (choice == 'Y' || choice == 'y')
       player_score_throw, non_scoring_dice_count = player.throw_dice non_scoring_dice_count
       puts "Players' scores: #{players_scores}"
       player_score_turn += player_score_throw
       
       if player_score_throw == 0
         puts "You are punished, greedy fellow!"
         skip = 1
         #break
         return skip, player_score_turn
       end
       
       if non_scoring_dice_count > 0
         puts "Your turn score is: #{player_score_turn}"
         print "Do you want to continue? (Y/N): "
         choice = gets.chomp
       end
     end
     
     return skip, player_score_turn
   end
   
   ##============================================================================##
   
   def pick_next_player(player_id)
     player_id += 1
     player_id %= @player_count
   end
   
   ##============================================================================##
   
   def play
     player_id = 0
     while true
         puts "\n======================\nPlayer #{player_id}"
         skip = 0
         player = @game_players[player_id]
         player_score_turn = 0
         player_score_throw, non_scoring_dice_count = player.throw_dice 5
         puts "Players' scores: #{players_scores}"
         
         # Account opens only when one scores more than 300 in a single turn
         if player_score_throw > 300 || players_scores[player_id] > 300
           player_score_turn += player_score_throw
           non_scoring_dice_count = (non_scoring_dice_count == 0) ? 5 : non_scoring_dice_count
           
           if non_scoring_dice_count > 0
             puts "Your turn score is: #{player_score_turn}"
             print "Do you want to continue? (Y/N): "
             choice = gets.chomp
           end 
           
           # Roll the dice until player rolls a zero-point roll to decides to stop rolling for the current turn
           skip, player_score_turn = roll_until_zero_point_or_player_decides_to_stop_rolling player, player_score_turn, choice, non_scoring_dice_count

           # Punish the player, don't credit any point for this turn, jump to the next player
           if skip == 1
             player_id = pick_next_player player_id
             next
           end
           
           # Credit points for this turn
           players_scores[player_id] += player_score_turn
           
           # Start the final round if the current player has accumulated more than 3000 points
           if players_scores[player_id] >= 3000 && !@final_round
             @final_round = true
             print "\n======================\nFinal turns"
             play
             break
           end
          
          # Current player hasn't scored >= 300 either in current turn or in any of the previous turns
          else
             puts "Account of player #{player_id} not opened yet."
          end
         
          # In the final round, each player will be allowed to take one last turn
          if @final_round
            @final_round_turn_count += 1
            if @final_round_turn_count == @player_count
              break
            end
          end
          player_id = pick_next_player player_id
       end
    end
    
  end
 
 ##============================================================================##
 
 game = Game.new(2)
 game.play
 puts "\n======================\n#{game.players_scores}"
