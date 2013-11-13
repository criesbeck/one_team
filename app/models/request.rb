class Request < ActiveRecord::Base
  validates_presence_of :title, :start_date, :end_date, :description
  validates_date :start_date, :on_or_before => :end_date,
                             :on_or_before_message => 'must be the same as or before the end date'
  validates_date :end_date,   :on_or_after => :today,
                             :on_or_after_message => 'must today or later'

  has_many :relevant_skills, dependent: :destroy
  has_many :skills_needed, through: :relevant_skills, :source => :skill
  has_many :responses
  has_one :assignment
  has_many :evaluations, through: :assignment

  has_one :group
  has_one :location

  self.per_page = 10

  def self.all_except_completed_or_cancelled
    r = where(date_cancelled: nil, date_completed: nil)
    r.where(["end_date > ?", Date.today])
  end

  def has_assignment?
    self.responses.each do |response|
      if response.assignment
        return true
      end
    end
    false
  end


  def print_skills_needed
    skills_needed.map(&:name).join(', ')
  end

  def passed_end_date?
    Date.today > end_date
  end

  def passed_start_date?
    Date.today >= start_date
  end    

  def start_date_status
    if date_cancelled
      'Cancelled on ' + date_cancelled.to_s
    elsif passed_end_date? && !date_completed
      'Unfulfilled'
    elsif date_completed
      'Completed on ' + date_completed.to_s
    elsif passed_start_date?
      'In progress'
    else
      'Not started'
    end
  end

  def find_matching_skills(variable_skills)
    matches = variable_skills & skills_needed
  end

  def print_matching_skills(variable_skills)
    matches = find_matching_skills(variable_skills)
    matches.empty? ? "None" : matches.map(&:name).join(', ')
  end

  def organize_skills(skills, matches)
    skills.where(skill_id: matches.map(&:id)).sort_by! {|x| x.skill_id} 
  end

  def qualified_count(cskills, current_skills)
    matches = find_matching_skills(cskills)
    levels = organize_skills(current_skills, matches).map(&:proficiency_level)
    levels.sum
  end

  def interest_count(dskills, desired_skills)
    matches = find_matching_skills(dskills)
    levels = organize_skills(desired_skills, matches).map(&:interest_level)
    levels.sum
  end
end
