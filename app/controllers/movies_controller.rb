# CN320 Software Engineering
# Semester 2/2555
# Homework #2 - Intro to Rails
# Theetawat Tangkhajiwarngkoon	ID: 5210612361
# Sira Thaweekitpaibul		ID: 5210611967

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # code ที่เขียนเพิ่ม
    # รับค่า key มาจาก controller เมื่อถูกคลิก
    @key = params[:key]
    
    # ดึงค่า ratings ทั้งหมดมาจาก model ที่สร้างไว้ โดยค่าจะเป็น array
    @all_ratings = Movie.all_ratings
    # รับค่า ratings เฉพาะตัวที่เลือกมาจาก controller เมื่อถูกคลิก โดยค่าจะเป็น array
    rate = params[:ratings]
    # สร้างไว้เก็บ ratings ที่เลือก โดยสร้างเป็น array
    @selected_ratings = []

    # Part III: RottenPotatoes enhancement
    # #3: remember the settings

    # ถ้ามี session จำตัวเลือก ratings ที่เลือก (ตัวแปร check) กรณีเข้ามาครั้งที่ 2 ขึ้นไป
    if session[:check]
      # ถ้าค่า ratings ที่รับมาว่าง กรณีไม่ได้เลือกตัวเลือกใหม่
      # นำค่าตัวแปร check ที่เก็บไว้มาให้ ratings (ดึง session เก่า)
      if rate == nil
        rate = session[:check]
      # ถ้าค่า ratings ที่รับมาไม่ว่าง กรณีเลือกตัวเลือกใหม่
      # นำค่า ratings ที่รับมาเก็บที่ตัวแปร check (เก็บ session ใหม่)
      else
        rate = params[:ratings]
        session[:check] = rate
      end
    # ถ้าไม่มี session จำตัวเลือก ratings ที่เลือก (ตัวแปร check) กรณีเข้ามาครั้งแรก
    # นำค่า ratings ที่รับมาเก็บที่ตัวแปร check (เก็บ session ครั้งแรก)
    else
      session[:check] = rate
    end

    # ถ้าค่า ratings ที่รับมาไม่ว่าง
    # ให้เลือก ratings ที่รับมาเก็บที่ selected_ratings โดยทำการวน loop จนครบทุกตัว
    if !rate.nil?
      rate.each_key do |key|
      @selected_ratings << key
    end
    # ถ้าค่า ratings ที่รับมาว่าง
    # ให้เลือก ratings ทั้งหมดมาเก็บที่ selected_ratings
    elsif
      @selected_ratings = @all_ratings
    end

    # ถ้า key = title แสดงว่า column heading ที่ถูกคลิกชื่อ Movie Title
    # ให้ค่า movie_name = hilite เวลาส่งค่ากลับไปที่ view จะได้เปลี่ยนสี column heading เป็นสีเหลือง
    # ให้ session จำ column heading ที่ถูกคลิก (ตัวแปร control) เป็นรูปแบบที่ 2
    if(@key == "title")
      @movie_name = "hilite"
      session[:control] = 2
    end
    # ถ้า key = release_date แสดงว่า column heading ที่ถูกคลิกชื่อ Release Date
    # ให้ค่า release_name = hilite เวลาส่งค่ากลับไปที่ view จะได้เปลี่ยนสี column heading เป็นสีเหลือง
    # ให้ session จำ column heading ที่ถูกคลิก (ตัวแปร control) เป็นรูปแบบที่ 3
    if(@key == "release_date")
      @release_name = "hilite"
      session[:control] = 3
    end

    # ถ้าค่า ratings ที่รับมาไม่ว่าง กรณีเลือกตัวเลือกใหม่
    if(rate != nil)
      # ถ้าตัวแปร control เป็นรูปแบบที่ 2
      if session[:control] == 2
        @key = "title"
        @movie_name = "hilite"
      end
      # ถ้าตัวแปร control เป็นรูปแบบที่ 3
      if session[:control] == 3
        @key = "release_ate"
        @release_name = "hilite"
      end
      # เพิ่ม method Movie.find เพื่อให้ข้อมูลแสดงเฉาะ ratings ที่เลือกและเรียงตาม key ที่กำหนด
      rate_array = rate.keys
      @movies = Movie.find(:all, :conditions => ["rating IN (?)",rate_array], :order => @key)
    # ถ้าค่า ratings ที่รับมาว่าง กรณีไม่ได้เลือกตัวเลือกใหม่
    elsif
      # เพิ่มคำสั่ง (:order => @key) เพื่อให้ข้อมูลเรียงตาม key ที่กำหนด
      @movies = Movie.all(:order => @key)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
