# CN320 Software Engineering
# Semester 2/2555
# Homework #2 - Intro to Rails
# Theetawat Tangkhajiwarngkoon	ID: 5210612361
# Sira Thaweekitpaibul		ID: 5210611967

class Movie < ActiveRecord::Base
  # code ที่เขียนเพิ่ม
  # สร้าง all_ratings ให้ controller เรียกใช้งาน
  # กำหนดค่า array ให้ instance variable ชื่อ all_rating
  def self.all_ratings
    @all_rating = ['G', 'PG', 'PG-13', 'R']
  end
end
