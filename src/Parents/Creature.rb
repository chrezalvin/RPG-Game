require "forwardable"
require "colorize"

require "utils/Event"
require "Parents/Stats/Hp"
require "Parents/Stats/Mp"
require "Parents/Stats/Atk"
require "Parents/Stats/Matk"
require "Parents/Stats/NaturalMpRegen"
require "Parents/Stats/NaturalHpRegen"
require "Parents/Damage"
require "Parents/Heal"
require "Parents/Effect"
require "Parents/Skill"

# Creature class
class Creature
  extend Forwardable
  
  # always available
  class << self
      attr_reader :description, :name
  end

    attr_reader :name, :usable_skills, :basic_attack, :effects, :on_use_skill, :on_effect_applied, :on_effect_expired,
      :current_hp, :max_hp, :on_heal, :on_get_hit, :on_dead, :on_hp_changed,
      :current_mp, :max_mp, :on_mp_used, :on_mp_added, :on_mp_changed,
      :atk_amount, :atk_colorized, 
      :matk_amount, :matk_colorized,
      :natural_hp_regen,
      :natural_mp_regen

    def_delegators :@hp, 
      :current_hp, 
      :current_hp_colorized, 
      :max_hp_colorized, 
      :max_hp, 
      :on_take_damage, 
      :on_heal,
      :on_dead, 
      :on_hp_changed
    def_delegators :@mp, 
      :current_mp, 
      :current_mp_colorized, 
      :max_mp_colorized, 
      :max_mp, 
      :on_mp_used, 
      :on_mp_added, 
      :on_mp_changed
    def_delegators :@atk, :atk_amount, :atk_colorized
    def_delegators :@matk, :matk_amount, :matk_colorized
    def_delegators :@nhpr, :natural_hp_regen
    def_delegators :@nmpr, :natural_mp_regen

    def_delegator :@use_skill_listeners, :subscribe, :on_use_skill
    def_delegator :@on_effect_applied_listeners, :subscribe, :on_effect_applied
    def_delegator :@on_effect_expired_listeners, :subscribe, :on_effect_expired

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

      @use_skill_listeners = Event.new()
      @on_effect_applied_listeners = Event.new()
      @on_effect_expired_listeners = Event.new()
    end

    def take_damage(damage)
      throw "Error: damage must be an instance of Damage, got #{damage.class}" unless damage.is_a? Damage

      unless damage.is_effect
        @effects.each{|effect| effect.on_before_take_damage(damage)}
      end

      @hp.take_damage(damage)

      unless damage.is_effect
        @effects.each{|effect| effect.on_after_take_damage(damage)}
      end
    end

    def heal(heal_instance)
      throw "Error: healInstance must be an instance of Heal, got #{heal_instance.class}" unless heal_instance.is_a? Heal

      @effects.each{|effect| effect.on_before_heal(heal_instance)}

      @hp.heal(heal_instance)

      @effects.each{|effect| effect.on_after_heal(heal_instance)}
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
          @use_skill_listeners.emit(@basic_attack, target)
          
          @basic_attack.use_skill(target)

          @effects.each{|effect| effect.on_after_use_skill(@basic_attack, target)}
        else
          throw "Error: Cannot use basic attack because the target is not Creature"
        end
    end

    def use_skill(idx, target)
      throw "Error: target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
      throw "Error: skill index must be an integer, got #{idx.class}" unless idx.is_a? Integer

      skill = @usable_skills[idx]
      
      throw "Error: skill is not an instance of Skill, got #{skill.class}" unless skill.is_a? Skill

      if skill.can_use_skill?(target)
        @effects.each{|effect| effect.on_before_use_skill(skill, target)}

        @use_skill_listeners.emit(skill, target)
        skill.use_skill(target)

        @effects.each{|effect| effect.on_after_use_skill(skill, target)}
      end
    end

    def use_skill_by_instance(skill, target)
      throw "Error: target must be an instance of Creature, got #{target.class}" unless target.is_a? Creature
      throw "Error: skill must be an instance of Skill, got #{skill.class}" unless skill.is_a? Skill

      if skill.can_use_skill?(target)
        @effects.each{|effect| effect.on_before_use_skill(skill, target)}

        @use_skill_listeners.emit(skill, target)
        skill.use_skill(target)

        @effects.each{|effect| effect.on_after_use_skill(skill, target)}
      end
    end

    def apply_effect(effect)
      throw "Error: effect must be an instance of Effect, got #{effect.class}" unless effect.is_a? Effect

      @effects.push(effect)

      @on_effect_applied_listeners.emit(effect)
    end

    def cleanup_expired_effects
      expired_effects = @effects.select{|effect| effect.is_expired?}
      @effects.reject!{|effect| effect.is_expired?}

      expired_effects.each do |effect|
        @on_effect_expired_listeners.emit(effect)
      end
    end

    def decide_next_action(creature)
      throw "Error: target must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

      nil
    end

    def is_dead?
      @hp.is_dead?
    end
end