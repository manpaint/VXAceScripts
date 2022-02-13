=begin
More Choices
by Fomar0153
Version 1.0
----------------------
Notes
----------------------
No requirements
Allows you to have more than four choices
----------------------
Instructions
----------------------
Edit the method more_choice and then use the call in 
a choice option.
----------------------
Known bugs
----------------------
None
=end
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● Edit Here
  # when handle
  #   $game_message.choices.push("a choice")
  #--------------------------------------------------------------------------
  def more_choice(p)
    case p
    when "npc_en"
      $game_message.choices.push("Talk")
      $game_message.choices.push("Trade")
      $game_message.choices.push("Rumors")
      $game_message.choices.push("Ask about...")
      $game_message.choices.push("Actions")
      $game_message.choices.push("Cancel")
    when "npc_fr"
      $game_message.choices.push("Talk")
      $game_message.choices.push("Trade")
      $game_message.choices.push("Rumors")
      $game_message.choices.push("Ask about...")
      $game_message.choices.push("Actions")
      $game_message.choices.push("Cancel")
      when "npc_en2"
      $game_message.choices.push("Threaten")
      $game_message.choices.push("Show item...")
      $game_message.choices.push("Give item...")
      $game_message.choices.push("Follow")
      $game_message.choices.push("Kill")
      $game_message.choices.push("Cancel")
      when "tele_en"
      $game_message.choices.push("Tower of the Magi")
      $game_message.choices.push("Ralgarth's Academy")
      $game_message.choices.push("Sulvania")
      $game_message.choices.push("Helliosian Church")
      $game_message.choices.push("Bridge of the Ancients")
      $game_message.choices.push("Sharid")
      $game_message.choices.push("Cancel")
    else
      $game_message.choices.push(p)
    end
  end
  #--------------------------------------------------------------------------
  # ● Long Choices - Don't edit this bit
  #--------------------------------------------------------------------------
  def setup_choices(params)
    for s in params[0]
      more_choice(s)
    end
    $game_message.choice_cancel_type = params[1]
    $game_message.choice_proc = Proc.new {|n| @branch[@indent] = n }
  end
end

class Window_ChoiceList < Window_Command
  #--------------------------------------------------------------------------
  # ● Feel free to change the 1 to another variable that you'd prefer
  #--------------------------------------------------------------------------
  alias mc_call_ok_handler call_ok_handler
  def call_ok_handler
    $game_variables[15] = index
    mc_call_ok_handler
  end
end
