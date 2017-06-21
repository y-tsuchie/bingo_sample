class Card

  # ビンゴカードの番号をランダムに作成
  # rowもクラスにしたい。。。また後で考える
  def initialize
    @row_b = (1..15).to_a.shuffle.take(5)
    @row_i = (16..30).to_a.shuffle.take(5)
    @row_n = (31..45).to_a.shuffle.take(4).insert(2, "×")
    @row_g = (46..60).to_a.shuffle.take(5)
    @row_o = (61..75).to_a.shuffle.take(5)
  end

  def rows
    [@row_b, @row_i, @row_n, @row_g, @row_o]
  end

  # カードに抽選番号があれば'×'に置き換え
  def punch_out(lottery_number)
    target_row = find_row(lottery_number)
    return unless target_row
    target_row.map! { |card_number| card_number == lottery_number ? "×" : card_number }
  end

  def puts_console
    columns = ["BINGO".chars] + rows.transpose

    columns.map do |column|
      puts column.map { |s| sprintf "%2s", s }.join("|")
    end
  end

  # ビンゴしてるか？
  def bingo?
    tate_bingo? || yoko_bingo? || naname_bingo?
  end

  private

  # 抽選番号がどの列にあるかを返す
  # ない場合はnilを返す
  def find_row(lottery_number)
    rows.find { |row| row.include?(lottery_number) }
  end

  # 縦ビンゴがあるか？
  def tate_bingo?
    rows.any? { |row| row.all? { |card_number| card_number == "×" } }
  end

  # 横ビンゴがあるか？
  def yoko_bingo?
    columns = rows.transpose
    columns.any? { |column| column.all? { |card_number| card_number == "×" } }
  end

  # 斜めビンゴがあるか？
  # 変数は時間がないため適当です・・・・・
  def naname_bingo?
    naname1 = rows.map.with_index { |row, i| row[i] }.all? { |card_number| card_number == "×" }
    naname2 = rows.reverse.map.with_index { |row, i| row[i] }.all? { |card_number| card_number == "×" }
    naname1 || naname2
  end
end

class BingiMachine

  def initialize
    @numbers = (1..75).to_a
    @drawn_numbers = []
  end

  def draw
    draw_number =  @numbers.sample
    @drawn_numbers << draw_number
    @numbers.delete(draw_number)
    draw_number
  end
end

machine = BingiMachine.new
card = Card.new

puts "ビンゴスタートです！！"
card.puts_console

while !card.bingo?
  puts "Enter key をクリックして抽選番号を引いてください"
  gets
  draw_number = machine.draw
  puts "=============================="
  puts "#{draw_number}を引きました"
  puts "=============================="
  card.punch_out(draw_number)
  card.puts_console
end

puts "おめでとう！"
