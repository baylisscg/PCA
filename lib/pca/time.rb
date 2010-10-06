=begin
=end

module TimeTools
  
  def elapsed
    sec = Time.now - self.created_at
    days, sec = sec.divmod(DAY) #if sec >= DAY
    hours, sec = sec.divmod(HOUR) #if sec >= HOUR
    min, sec  = sec.divmod(MINUTE) #if sec >= MINUTE
    
    return "%d:%02d:%02d:%06.3f"%[days,hours,min,sec]
  end
  
  MINUTE = 60
  HOUR = MINUTE * MINUTE
  DAY  = HOUR * 24
  
  def self.sec_to_units(sec)
    
    seconds = sec % 60
    mins  = ((sec % HOUR)/MINUTE).to_i
    hours = ((sec % DAY)/HOUR).to_i
    days  = (sec / DAY).to_i
    puts "#{sec}s = #{days}:#{hours}:#{mins}:#{sec}"
    
  end
  
end
