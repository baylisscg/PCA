#
#
#

#
#
#
class Node
  
  # Source point of a digraph
  class SourceNode < Node;
    def initialize(args={})
      super args.merge({:name=>:source,:depth=>0})
    end

    def get_trace
      super.select []
    end
    
#    def select(args)
#      return super []
#    end

    def to_s
      "Source Node children: #{@children.length}"
    end

  end

  # Sink node
  class SinkNode < Node;
    
    def initialize(args={})
      super args.merge({:name=>:sink,:depth=>-1})
    end

    def node; end

    def sink; end

    def to_s
      "Sink Node."
    end

    def to_str
      ""
    end

    def select(args)
      return args
    end

    def root_node; false; end
    def leaf_node; true; end
  end

  attr_accessor :name
  
  #
  #
  #
  def initialize(params={})
    @name   = params[:name]   if params[:name]
    @parent = params[:parent] if params[:parent]
    @depth  = params[:depth]  if params[:depth]
    @value  = params[:value]  if params[:value]
    @sink   = params[:sink]   if params[:sink]
    @children = {}
  end
  
  def value
    if @value then @value; else @name; end
  end

  def to_s
    x = "Node "
    x << "#{@name} " if @name
    x << "parent: #{@parent.name} " if @parent
    x << "depth: #{@depth} " if @depth
    x << "children: #{@children.length}"
  end
  
  def node(name, value=name, args={}, &block)
    new_node = Node.new({:name=>name,
                          :sink=>@sink,
                          :value=>value,
                          :depth=>@depth+1,
                          :parent=>self}.merge(args))
    @children[name] = new_node
    new_node.instance_eval &block if block
  end
  
  def root_node?
    @parent.instance_of? SourceNode
  end

  def sink
    if not @children[:sink]
      @children[:sink] = @sink 
    end
  end
  
  def leaf_node?
    @children.empty?
  end

  def select(list)
    list << self unless self.instance_of? SourceNode
    if not leaf_node?
      x = @children[@children.keys[rand(@children.length)]]
      return x.select(list)
    else
      return list
    end
  end

  #
  #
  #
  def to_str
    x = ("  " *@depth)
    if self.root_node?
      x << "[#{@name}] Root Node\n" 
      elsif self.leaf_node?
      x << "[#{@name}] Leaf\n"
      # Yes we could skip out here but this way we only have one exit point.
    else
      x << "[#{@name}] Node\n"
    end

    @children.each { |k,v| x << v.to_str }

    return x
  end

end



#
#
#
class Digraph
    
  #
  #
  #
  def initialize(params={})
    @name = params[:name] || "unnamed"
    @source = Node::SourceNode.new
    @sink   = Node::SinkNode.new
  end
    
  #
  #
  #
  def node(name, value=name, args={}, &block); @source.node(name, value, args.merge({:sink=>@sink}), &block) end
  
  def to_s; self.to_str; end

  def to_str
    @source.to_str
  end

  def get_trace
    @source.select []
  end

  
  @@digraphs = {}
  
  #
  #
  #
  def self.create(name, &block)
    x = Digraph.new(:name=>name)
    @@digraphs[name] = x
    x.instance_eval &block if block
  end
  
  #
  # 
  #
  def self.[](name) 
    @@digraphs[name]
  end
  
end

Digraph.create :test do 
  node :gsi_ok, "GSI Connect" do
    node :gram_sub, "GRAM Submit" do
      node :gram_start, "GRAM Job Start" do
        node :gram_finish, "GRAM Job Complete"
        node :gram_fail,   "GRAM Job Fail"
      end
      node :gram_reject, "GRAM Submit Failed"
    end
    node :wms_submit, "WMS Submit" do
      node :gsi_ok, "GSI Connect" do
        node :gram_sub, "GRAM Submit" do
          node :gram_start, "GRAM Job Start" do
            node :gram_finish, "GRAM Job Complete"
            node :gram_fail,   "GRAM Job Fail"
          end
          node :gram_reject, "GRAM Submit Failed"
        end
        node :gsi_fail, "GSI Reject"
      end
      node :wms_submit, "WMS Submit Fail"
    end
  end
  node :gsi_fail, "GSI Reject" 
end

#puts Digraph[:test]
#trace  = Digraph[:test].get_trace
#values = trace.map { |node| node.value }
#puts values
