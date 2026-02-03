require_relative "../Damages/Damage"
require_relative "../Damages/BasicDamage"

class Creature
    attr_reader :hp, :mp, :atk, :is_dead, :name

    @@initial_hp = 100
    @@initial_mp = 100
    @@initial_atk = 10
    def initialize()
        @hp = @@initial_hp
        @mp = @@initial_mp
        @atk = @@initial_atk
        @name = "Unknown Creature"
        @usable_skills = []
        @is_dead = false
    end

    def take_damage(damage)
        prev_hp = @hp
        if damage.is_a? Damage
            @hp -= damage.damage
        end

        prev_hp - @hp
    end

    def basic_attack(target)
        if target.is_a? Creature
            target.take_damage(BasicDamage.new(@atk, self))
        else
            0
        end
    end
end