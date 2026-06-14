require "forwardable"
require "colorize"

require "utils/Event"
require "Parents/Stats/Hp"
require "Parents/Stats/Mp"
require "Parents/Stats/Atk"
require "Parents/Stats/Matk"
require "Parents/Stats/NaturalMpRegen"
require "Parents/Stats/NaturalHpRegen"
require "Parents/Stats/Accuracy"
require "Parents/Stats/Dodge"
require "Parents/Stats/Defense"
require "Parents/Stats/Speed"
require "Parents/Stats/Turn"
require "Parents/Stats/Effects"
require "Parents/Stats/Skills"

require "Parents/Actionable/Damageable"
require "Parents/Actionable/Healable"
require "Parents/Actionable/MpHealable"
require "Parents/Actionable/MpUseable"
require "Parents/Actionable/Killable"
require "Parents/Actionable/DamageDefReduceable"
require "Parents/Actionable/DamageAvoidable"
require "Parents/Actionable/Effectable"
require "Parents/Actionable/SkillUsable"
require "Parents/Actionable/Turnable"
require "Parents/Actionable/Fightable"
require "Parents/Actionable/Soundable"

# Creature class
class Creature
  extend Forwardable
  
  # always available
  class << self
      attr_reader :description, :name
  end

  # stats components
  attr_reader :atk, 
    :hp, 
    :mp,
    :matk, 
    :defense, 
    :nmpr, 
    :nhpr, 
    :acc, 
    :dodge, 
    :speed, 
    :turns,
    :effects,
    :skills

  # actionable components
  attr_reader :damageable, 
    :healable, 
    :mp_healable, 
    :mp_usable, 
    :killable, 
    :effectable, 
    :skill_usable,
    :turnable,
    :fightable,
    # :soundable,
    :damage_avoid,
    :damage_def_reduce,

    # # TODO: to be removed
    # :on_about_to_fight_listeners,
    # :on_being_ambushed_listeners

    # @return [String] the name of the creature
    def name
      self.class.name
    end

    # @return [String] the description of the creature
    def description
      self.class.description
    end

    # @return [String] the name of the creature in colorized format
    def name_colorized
      self.class.name.to_s.colorize(:light_yellow)
    end

    # @type [String, nil]
    @description = nil

    # @type [String]
    @name = "Unknown Creature"

    # @param hp [Integer] the initial and maximum HP of the creature
    # @param mp [Integer] the initial and maximum MP of the creature
    # @param atk [Integer] the attack stat of the creature
    # @param matk [Integer] the magic attack stat of the creature
    # @param defense [Integer] the defense stat of the creature
    # @param nmpr [Integer] the natural MP regeneration of the creature
    # @param nhpr [Integer] the natural HP regeneration of the creature
    def initialize(
      hp: nil, 
      mp: nil, 
      atk: nil,
      matk: nil, 
      defense: nil,
      nmpr: nil, 
      nhpr: nil,
      acc: nil,
      dodge: nil,
      speed: nil,
      effects: nil,
      skills: nil
    )
      # Stats components
      # @type [Hp]
      @hp = Hp.new(current_hp: hp, max_hp: hp)
      # @type [Mp]
      @mp = Mp.new(current_mp: mp, max_mp: mp)
      # @type [Atk]
      @atk = Atk.new(amount: atk)
      # @type [Matk]
      @matk = Matk.new(amount: matk)
      # @type [Defense]
      @defense = Defense.new(amount: defense)
      # @type [Accuracy]
      @acc = Accuracy.new(amount: acc)
      # @type [Dodge]
      @dodge = Dodge.new(amount: dodge)
      # @type [NaturalMpRegen]
      @nmpr = NaturalMpRegen.new(amount: nmpr)
      # @type [NaturalHpRegen]
      @nhpr = NaturalHpRegen.new(amount: nhpr)
      # @type [Speed]
      @speed = Speed.new(amount: speed)
      # @type [Turn]
      @turns = Turn.new()
      # @type [Effects]
      @effects = Effects.new()
      # @type [Skills]
      @skills = Skills.new([], self)

      # Actionable components
      # @type [Damageable]
      @damageable = Damageable.new(@hp)
      # @type [Healable]
      @healable = Healable.new(@hp)
      # @type [MpHealable]
      @mp_healable = MpHealable.new(@mp)
      # @type [MpUsable]
      @mp_usable = MpUseable.new(@mp)
      # @type [Killable]
      @killable = Killable.new(@hp)
      # @type [Effectable]
      @effectable = Effectable.new(@effects, self)
      # @type [SkillUsable]
      @skill_usable = SkillUsable.new(self)
      # @type [Turnable]
      @turnable = Turnable.new(@turns)
      # @type [Fightable]
      @fightable = Fightable.new()
      # # @type [Soundable]
      # @soundable = Soundable.new()
      
      # Default Actions
      # @type [DamageAvoid]
      @damage_avoid = DamageAvoidable.new(@dodge, @damageable)
      # @type [DamageDefReduce]
      @damage_def_reduce = DamageDefReduceable.new(@defense, @damageable)


      # # TODO: to be removed
      # @on_about_to_fight_listeners = Event.new()
      # @on_being_ambushed_listeners = Event.new()
    end

    # # @param creature [Creature] the creature to fight against
    # def try_fight(creature)
    #   throw "Error: creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

    #   @on_about_to_fight_listeners.emit(creature)
    # end

    # # @param creature [Creature] the creature that is ambushing this creature
    # def ambushed(creature)
    #   throw "Error: creature must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

    #   @on_being_ambushed_listeners.emit(creature)
    # end

    # @param creature [Creature] the creature to decide the next action against
    # @return [Integer, nil] the index of the skill to be used in the usable_skills array, nil if no skill is to be used
    def decide_next_action(creature)
      throw "Error: target must be an instance of Creature, got #{creature.class}" unless creature.is_a? Creature

      # random of skills
      random_idx = rand(0...self.skills.skills.length)

      return random_idx
    end
end