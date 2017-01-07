# 改札口を表すクラスです。
#
# @example 梅田で180円の切符を購入して乗車し、庄内で降車する
#   ticket = Ticket.new(180)
#   umeda = Gate.new(:umeda)
#   shonai = Gate.new(:shonai)
#   umeda.enter(ticket)
#   shonai.exit(ticket) #=> true
#
# @example 梅田で150円の切符を購入して乗車し、庄内で降車する
#   ticket = Ticket.new(150)
#   umeda = Gate.new(:umeda)
#   shonai = Gate.new(:shonai)
#   umeda.enter(ticket)
#   shonai.exit(ticket) #=> false
class Gate
  # 駅の名前を返します。
  # @return [Symbol] 駅の名前
  attr_reader :name

  # 改札口を初期化します。
  # @param name [Symbol] 駅の名前
  def initialize(name)
    @name = name
  end

  # 改札口から入場します。<br>
  # 切符には駅の名前が記録されます。
  # @param ticket [Ticket] 切符
  # @raise [AlreadyEnteredTicketError] すでに入場済みの切符を使った場合に発生します。
  def enter(ticket)
    unless ticket.from.nil?
      begin
        raise AlreadyEnteredTicketError
      end
    end
    ticket.enter(@name)
  end

  # 改札口から出場します。<br>
  # 切符の運賃が足りていればtrueを返し、切符を使用済みにします。
  # @param ticket [Ticket] 切符
  # @return [Boolean] 運賃が足りていればtrue、不足していればfalse
  # @raise [StaleTicketError] 使用済みの切符を使った場合に発生します。
  # @raise [NotEnteredTicketError] 未入場の切符を使った場合に発生します。
  # @raise [ExitSameStationError] 乗車駅と同じ駅で出場した場合に発生します。
  def exit(ticket)
    if ticket.fee == -1
      begin
        raise StaleTicketError
      end
    end

    if ticket.from.nil?
      begin
        raise NotEnteredTicketError
      end
    end

    case @name
    when ticket.from then
      begin
        raise ExitSameStationError
      end
      ret = false
    when :umeda then
      ret = true if ticket.from == :juso && ticket.fee >= 150
      ret = true if ticket.from == :shonai && ticket.fee >= 180
      ret = true if ticket.from == :okamachi && ticket.fee >= 220
    when :juso then
      ret = true if ticket.from == :umeda && ticket.fee >= 150
      ret = true if ticket.from == :shonai && ticket.fee >= 150
      ret = true if ticket.from == :okamachi && ticket.fee >= 180
    when :shonai then
      ret = true if ticket.from == :umeda && ticket.fee >= 180
      ret = true if ticket.from == :juso && ticket.fee >= 150
      ret = true if ticket.from == :okamachi && ticket.fee >= 150
    when :okamachi then
      ret = true if ticket.from == :umeda && ticket.fee >= 220
      ret = true if ticket.from == :juso && ticket.fee >= 180
      ret = true if ticket.from == :shonai && ticket.fee >= 150
    else
      ret = false
    end
    ticket.mark_as_stale
    ret
  end

  private

  def exitable?(ticket)
  end
end
