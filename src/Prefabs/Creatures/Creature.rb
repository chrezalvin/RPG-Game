require_relative "../Damages/Damage"
require_relative "../Damages/BasicDamage"
require_relative "../Skills/Skill"

class Creature
    attr_reader :hp, :mp, :atk, :is_dead, :name, :usable_skills

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

        @get_hit_listeners = []
        @use_skill_listeners = []
        @on_dead_listeners = []
    end

    def take_damage(damage)
        prev_hp = @hp
        if damage.is_a? Damage
            @hp -= damage.damage
        end

        @get_hit_listeners.each{
            |listener| listener.call(self, prev_hp - @hp)
        }

        if @hp <= 0
            @on_dead_listeners.each{
                |listener| listener.call(self)
            }  
        end
    end

    def basic_attack(target)
        if target.is_a? Creature
            target.take_damage(BasicDamage.new(@atk, self))
        else
            0
        end
    end

    def use_skill(idx, target)
        if target.is_a? Creature
            skill = @usable_skills[idx]
            if skill.is_a? Skill
                if skill.can_use_skill?(target)
                    @use_skill_listeners.each{|listener| listener.call(self, skill, target)}

                    skill.use_skill(target)
                end
            end
        end
    end

    def add_on_get_hit_listeners(listener)
        @get_hit_listeners.push(listener)
    end

    def add_on_use_skill_listeners(listener)
        @use_skill_listeners.push(listener)  
    end

    def add_on_dead_listeners(listener)
        @on_dead_listeners.push(listener)  
    end
end