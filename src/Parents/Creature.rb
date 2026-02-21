require "forwardable"

require_relative "./Stats/Hp"
require_relative "./Stats/Mp"
require_relative "./Stats/Atk"
require_relative "./Stats/Matk"
require_relative "./Stats/NaturalMpRegen"
require_relative "./Stats/NaturalHpRegen"
require_relative "./Damage"
require_relative "./Effect"

require_relative "./Skill"
require "colorize"

# Creature class
class Creature
  extend Forwardable
  
  # always available
  class << self
      attr_reader :description, :name
  end

    attr_reader :atk, :matk, :name, :usable_skills, :basic_attack, :effects,
      :current_hp, :max_hp, :add_on_heal_listener, :add_on_get_hit_listener, :add_on_dead_listener, :add_on_hp_changed_listener,
      :current_mp, :max_mp, :add_on_mp_used_listener, :add_on_mp_added_listener, :add_on_mp_changed_listener,
      :natural_hp_regen,
      :natural_mp_regen

    def_delegators :@hp, :current_hp, :max_hp, :add_on_heal_listener, :add_on_get_hit_listener, :add_on_dead_listener, :add_on_hp_changed_listener
    def_delegators :@mp, :current_mp, :max_mp, :add_on_mp_used_listener, :add_on_mp_added_listener, :add_on_mp_changed_listener
    def_delegators :@nhpr, :natural_hp_regen
    def_delegators :@nmpr, :natural_mp_regen

    def name
      self.class.name
    end

    def description
      self.class.description
    end

    def name_colorized
      self.class.name.to_s.colorize(:light_yellow)
    end

    @description = nil
    @name = "Unknown Creature"
    def initialize(
      hp: nil, 
      mp: nil, 
      atk: nil,
      matk: nil, 
      nmpr: nil, 
      nhpr: nil
    )
      @hp = Hp.new(current_hp: hp, max_hp: hp)
      @mp = Mp.new(current_mp: mp, max_mp: mp)
      @atk = Atk.new(amount: atk)
      @matk = Matk.new(amount: matk)
      @nmpr = NaturalMpRegen.new(natural_mp_regen: nmpr)
      @nhpr = NaturalHpRegen.new(natural_hp_regen: nhpr)

      @basic_attack = nil
      @usable_skills = []
      @effects = []

      @use_skill_listeners = []
      @on_effect_applied_listeners = []
      @on_effect_expired_listeners = []
    end

    def take_damage(damage)
      if damage.is_a? Damage
        unless damage.is_effect
          @effects.each{|effect| effect.on_before_take_damage(damage)}
        end

        @hp.take_damage(damage.damage)

        unless damage.is_effect
          @effects.each{|effect| effect.on_after_take_damage(damage)}
        end
      else
        throw "Error: damage is not from Damage class"
      end
    end

    def heal(amount)
      @effects.each{|effect| effect.on_before_heal(amount)}

      @hp.heal(amount)

      @effects.each{|effect| effect.on_after_heal(amount)}
    end

    def use_mp(amount)
      @mp.use_mp(amount)
    end

    def regenerate_mp
      @nmpr.regenerate(@mp)
    end

    def regenerate_hp
      @nhpr.regenerate(@hp)
    end

    def use_basic_attack(target)
        if (target.is_a? Creature) && (@basic_attack != nil)
          
          @effects.each{|effect| effect.on_before_use_skill(@basic_attack, target)}
          @use_skill_listeners.each{|listener| listener.call(@basic_attack, target)}
          
          @basic_attack.use_skill(target)

          @effects.each{|effect| effect.on_after_use_skill(@basic_attack, target)}
        else
          throw "Error: Cannot use basic attack because the target is not Creature"
        end
    end

    def use_skill(idx, target)
        if target.is_a? Creature
            skill = @usable_skills[idx]
            if skill.is_a? Skill
                if skill.can_use_skill?(target)
                    @effects.each{|effect| effect.on_before_use_skill(skill, target)}

                    @use_skill_listeners.each{|listener| listener.call(skill, target)}
                    skill.use_skill(target)

                    @effects.each{|effect| effect.on_after_use_skill(skill, target)}
                end
            end
        end
    end

    def apply_effect(effect)
      throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

      @effects.push(effect)

      @on_effect_applied_listeners.each{|listener| listener.call(effect)}
    end

    def cleanup_expired_effects
      expired_effects = @effects.select{|effect| effect.is_expired?}
      @effects.reject!{|effect| effect.is_expired?}

      expired_effects.each do |effect|
        @on_effect_expired_listeners.each{|listener| listener.call(effect)}
      end
    end

    def decide_next_action(creature)
      unless creature.is_a? Creature
        throw "Error: creature must be an instance of Creature, got #{creature.class}"
      end

      nil
    end

    def add_on_use_skill_listener(listener)
      @use_skill_listeners.push(listener)  
    end

    def add_on_effect_applied_listener(listener)
      @on_effect_applied_listeners.push(listener)
    end

    def add_on_effect_expired_listener(listener)
      @on_effect_expired_listeners.push(listener)
    end
end