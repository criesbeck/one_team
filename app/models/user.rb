class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  validates_numericality_of :years_with_company, :message => "is not a number", on: :update

  has_one :position
  has_one :department
  has_one :group
  has_one :location

  has_many :responses
  has_many :assignments, through: :responses
  has_many :evaluations, through: :assignments

  has_many :current_skills, dependent: :destroy
  has_many :cskills, through: :current_skills, :source => :skill
  accepts_nested_attributes_for :current_skills

  has_many :desired_skills, dependent: :destroy
  has_many :dskills, through: :desired_skills, :source => :skill
  accepts_nested_attributes_for :desired_skills

  mount_uploader  :image, ImageUploader

  def print_skills(skills)
    skills.map(&:name).join(', ')
  end

  def setup_skills
    (Skill.all - self.cskills).each do |skill|
      self.current_skills.build(:skill_id => skill.id)
    end
    
    (Skill.all - self.dskills).each do |skill|    
      self.desired_skills.build(:skill_id => skill.id)
    end
  end

  def build_user_overall_skill_evaluation_table(current_user)
    table_array = []

    Skill.all.each do |skill|
      evals = self.evaluations.where(skill_id: skill.id)
      total_xp = evals.map(&:experience_points).sum
      if id == current_user
        avg_lvl = evals.map(&:proficiency_level_judgment).sum / (evals.count.nonzero? || 1)
        table_array.push([skill.name, total_xp, avg_lvl])
      else
        table_array.push([skill.name, total_xp])
      end
    end
    table_array
  end

  def build_user_project_skill_evaluation_table(current_user)
    eval_skill_ids = self.evaluations.map(&:skill_id).compact
    matching_skills = Skill.where(id: eval_skill_ids)       
    table_array = []

    matching_skills.each do |skill|
      evals = self.evaluations.where(skill_id: skill.id)
      xp = evals.map(&:experience_points).sum
      if id == current_user
        lvl = evals.map(&:proficiency_level_judgment).sum
        table_array.push([skill.name, xp, lvl])
      else
        table_array.push([skill.name, xp])
      end
    end
    table_array
  end


end
