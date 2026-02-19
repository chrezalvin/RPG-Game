require "forwardable"

require_relative "./Hp"
require_relative "./Mp"
require_relative "./Damage"
require_relative "./Atk"

require_relative "./Skill"
require "colorize"

# Creature class
class Creature
  extend Forwardable
    attr_reader :atk, :name, :usable_skills, :basic_attack,
      :current_hp, :max_hp, :add_on_heal_listener, :add_on_get_hit_listener, :add_on_dead_listener, :add_on_hp_changed_listener,
      :current_mp, :max_mp, :add_on_mp_used_listener, :add_on_mp_added_listener, :add_on_mp_changed_listener

    def_delegators :@hp, :current_hp, :max_hp, :add_on_heal_listener, :add_on_get_hit_listener, :add_on_dead_listener, :add_on_hp_changed_listener
    def_delegators :@mp, :current_mp, :max_mp, :add_on_mp_used_listener, :add_on_mp_added_listener, :add_on_mp_changed_listener

    @@description = nil
    def initialize()
        @hp = Hp.new()
        @mp = Mp.new()
        @atk = Atk.new()

        @name = "Unknown Creature"
        @basic_attack = nil
        @usable_skills = []

        @use_skill_listeners = []
    end

    def take_damage(damage)
      if damage.is_a? Damage
        @hp.take_damage(damage.damage)
      else
        throw "Error: damage is not from Damage class"
      end
    end

    def heal(amount)
      @hp.heal(amount)
    end

    def use_mp(amount)
      @mp.use_mp(amount)
    end

    def use_basic_attack(target)
        if (target.is_a? Creature) && (@basic_attack != nil)
          @use_skill_listeners.each{|listener| listener.call(@basic_attack, target)}

          @basic_attack.use_skill(target)
        else
          throw "Error: Cannot use basic attack because the target is not Creature"
        end
    end

    def use_skill(idx, target)
        if target.is_a? Creature
            skill = @usable_skills[idx]
            if skill.is_a? Skill
                if skill.can_use_skill?(target)
                    @use_skill_listeners.each{|listener| listener.call(skill, target)}

                    skill.use_skill(target)
                end
            end
        end
    end

    def self.description
      @@description
    end

    def add_on_use_skill_listener(listener)
      @use_skill_listeners.push(listener)  
    end

    def name_colorized
      @name.to_s.colorize(:light_yellow)
    end
end