require "dm-validations"
class Subject
  include DataMapper::Resource
  property :id,         Serial
  property :title,      String
  property :created_at, DateTime, :index => true
  has n, :rants, :order => [:created_at.desc]
  
  validates_present :title
  
  before(:create) do
    self.created_at = DateTime.now
  end
  
  def self.find_or_create(subject)
    s = first(:title => subject)
    s = create(:title => subject) unless s
    s
  end
end

class Rant
  include DataMapper::Resource
  property :id,         Serial, :index => :related_rant
  property :line,       String
  property :created_at, DateTime, :index => :related_rant
  
  belongs_to :subject
  
  validates_present :line
  
  before(:create) do
    self.created_at = DateTime.now
  end
end

class LolUAllSuk < Merb::Controller

  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    @subjects = Subject.all(:limit => 100, :order => [:created_at.desc])
    render
  end
  
  def search
    @subject = Subject.find_or_create(params[:title])
    redirect url(:action => :show, :id => @subject.id)
  end
  
  def show
    @subject = Subject.get(params[:id])
    return redirect(url(:action => :index)) unless @subject
    @rants = @subject.rants(:limit => 100)
    render
  end
  
  def save
    @subject = Subject.get(params[:id])
    @rant = @subject.rants.create(:line => params[:line])
    redirect url(:action => :show, :id => params[:id])
  end
  
private 
  
  def time_format(time)
    time.strftime("%H:%M")
  end
end

