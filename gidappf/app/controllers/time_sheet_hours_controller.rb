###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>               #
# Tutores:                                                                #
#    - UNAJ: Dr. Ing. Morales, Martín                                     #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                            #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                               #
#    - TAPTA: Dra. Ferrari, Mariela                                       #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
# Archivo GIDAPPF/gidappf/app/controllers/time_sheet_hours_controller.rb  #
###########################################################################
class TimeSheetHoursController < ApplicationController
  before_action :set_time_sheet_hour, only: [:show, :edit, :update, :destroy]

  # GET /time_sheet_hours
  # GET /time_sheet_hours.json
  def index
    authorize @time_sheet_hours = TimeSheetHour.all
    @time_sheets = TimeSheet.where(end_date: Date.today .. 1.year.after).where(enabled:true)
  end

  # GET /time_sheet_hours/1
  # GET /time_sheet_hours/1.json
  def show
  end

  # GET /time_sheet_hours/new
  def new
    authorize @time_sheet_hour = TimeSheetHour.new
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # GET /time_sheet_hours/1/edit
  def edit
    respond_to do |format|
      format.html { }
      format.json { head :no_content }
    end
  end

  # POST /time_sheet_hours
  # POST /time_sheet_hours.json
  def create
    authorize @time_sheet_hour = TimeSheetHour.new(time_sheet_hour_params)
    respond_to do |format|
      if @time_sheet_hour.save
        format.html { redirect_to @time_sheet_hour, notice: 'Time sheet hour was successfully created.' }
        format.json { render :show, status: :created, location: @time_sheet_hour }
      else
        format.html { render :new }
        format.json { render json: @time_sheet_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_sheet_hours/1
  # PATCH/PUT /time_sheet_hours/1.json
  def update
    respond_to do |format|
      if @time_sheet_hour.update(time_sheet_hour_params)
        format.html { redirect_to @time_sheet_hour, notice: 'Time sheet hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_sheet_hour }
      else
        format.html { render :edit }
        format.json { render json: @time_sheet_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_sheet_hours/1
  # DELETE /time_sheet_hours/1.json
  def destroy
    authorize @time_sheet_hour.destroy
    respond_to do |format|
      format.html { redirect_to time_sheet_hours_url, notice: 'Time sheet hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def hours_free(class_room_institute,day_order)
    out = ''
    arr=hole_time(class_room_institute,day_order)
      unless arr.nil?
        y=2000
        m=12
        d=31
        z="+00:00"
        arr.each do |e|
          out += Time.new(y, m, d, (e.first/60).round, e.first%60, 0, z).strftime('%R')
          out += '~'
          out += Time.new(y, m, d, (e.last/60).round, e.last%60, 0, z).strftime('%R ')
        end
      else
        out=' - '
      end
    out
    # hole_time(class_room_institute,day_order).to_s
  end
  helper_method :hours_free

  def occupied_hour_fmt(time_sheet_hour)
    Time.new(2000, 12, 31, time_sheet_hour.from_hour, time_sheet_hour.from_min, 0, "+00:00").strftime('%R')+'~'+Time.new(2000, 12, 31, time_sheet_hour.to_hour, time_sheet_hour.to_min, 0, "+00:00").strftime('%R')
  end
  helper_method :occupied_hour_fmt

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_sheet_hour
      authorize @time_sheet_hour = TimeSheetHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_sheet_hour_params
      params.require(:time_sheet_hour).permit(:vacancy_id, :time_sheet_id, :from_hour, :from_min, :to_hour, :to_min, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday)
    end

      ###################################################################################
      # Prerequisitos:                                                                  #
      #           1) Modelo de datos inicializado.                                      #
      #           2) Misma codificacion del campo available_time de ClassRoomInstitute. #
      # parámetros:                                                                     #
      #           class_room_institute - instancia del aula.                            #
      # Devolución: Arreglo concatenando los intervalos en minutos libres según la      #
      #             disponibilidad del aula.                                            #
      ###################################################################################
      def hole_time(class_room_institute,day_order)
        hole=Array.new
        x=class_room_institute.available_time
        case x
          when 812 #'Disponible de 8 a 12 hs.'
            hole=nil_to_cron(hole_from_to_cron(8*60,12*60,class_room_institute,day_order))
          when 12 #"Disponible de 0 a 12 hs."
            hole=nil_to_cron(hole_from_to_cron(0,12*60,class_room_institute,day_order))
          when 24 #"Disponible las 24 hs."
            hole=nil_to_cron(hole_from_to_cron(0,24*60,class_room_institute,day_order))
          when 1022 #"Disponible de 10 a 22 hs."
            hole=nil_to_cron(hole_from_to_cron(10*60,22*60,class_room_institute,day_order))
          when 1624 #"Disponible de 16 a 24 hs."
            hole=nil_to_cron(hole_from_to_cron(16*60,24*60,class_room_institute,day_order))
          else #"Sin frase en la opción: #{x}."
          end
        hole
      end

    ###################################################################################
    # Prerequisitos:                                                                  #
    #           1) Modelo de datos inicializado.                                      #
    #           2) Misma codificacion del campo available_time de ClassRoomInstitute. #
    # parámetros:                                                                     #
    #           from_hour - decodificación de hora de disponibilidad desde.           #
    #           to_hour - decodificación de hora de disponibilidad hasta              #
    #           class_room_institute - instancia del aula                             #
    # Devolución: Arreglo concatenando los intervalos en minutos libres según la      #
    #             disponibilidad decodificada en el aula                              #
    ###################################################################################
    # def hole_from_to(from_min_day, to_min_day,class_room_institute,day_order)
    #   hole=Array.new
    #   a=TimeSheetHour.where(vacancy: Vacancy.find_by(class_room_institute: class_room_institute))
    #   time_sheet_hours=Array.new
    #   a.each do |t|
    #     unless t.from_hour == 0 && t.from_min == 0 && t.to_hour == 0 && t.to_min == 0 then
    #       time_sheet_hours << t
    #     end
    #   end
    #   w=days_week_available(class_room_institute)
    #   if w[day_order] then
    #     time_sheet_hours.each do |time_sheet_hour|
    #       tw=hour_week(time_sheet_hour)
    #       if tw[day_order] then
    #         hole << holes_detect_g35(from_min_day, to_min_day, time_sheet_hour.to_hour, time_sheet_hour.to_min, time_sheet_hour.from_hour, time_sheet_hour.from_min)
    #       end
    #     end
    #   else
    #     hole=nil
    #   end
    #   hole
    # end

    #################################################################################
    # Usado en hole_from_to                                                         #
    #################################################################################
    def days_week_available(class_room_institute)
      week=Array.new
      week << class_room_institute.available_monday
      week << class_room_institute.available_tuesday
      week << class_room_institute.available_wednesday
      week << class_room_institute.available_thursday
      week << class_room_institute.available_friday
      week << class_room_institute.available_saturday
      week << class_room_institute.available_sunday
      week
    end

    #################################################################################
    # Usado en hole_from_to                                                         #
    #################################################################################
    def hour_week(time_sheet_hour)
      week=Array.new
      week << time_sheet_hour.monday
      week << time_sheet_hour.tuesday
      week << time_sheet_hour.wednesday
      week << time_sheet_hour.thursday
      week << time_sheet_hour.friday
      week << time_sheet_hour.saturday
      week << time_sheet_hour.sunday
      week
    end

    ###################################################################################
    # Prerequisitos:                                                                  #
    #           1) Modelo de datos inicializado.                                      #
    # parámetros:                                                                     #
    #           free - arreglo de inervalos en horas desde y horas hasta.             #
    #           to_hour - horario hasta usado truncado en horas                       #
    #           to_min - horario hasta usado, minutos complementarios                 #
    #           from_hour - horario desde usado truncado en horas                     #
    #           from_min - horario desde usado, minutos complementarios               #
    # Devolución: Arreglo concatenando los intervalos en minutos libres según la      #
    #             disponibilidad decodificada en el aula                              #
    ###################################################################################
    # def holes_detect_g35(from_min_day, to_min_day, to_hour, to_min, from_hour, from_min)
    #   hole=nil
    #   unless delta(to_hour, to_min, from_hour, from_min) <= 30 ||from_min_day.nil?||to_min_day.nil? then
    #     hole=Array.new
    #     # Tiempo ocupado: from_hour:from_min hasta to_hour:to_min
    #     last_part=delta(to_min_day/60, to_min_day%60, from_hour, from_min)
    #     first_part=delta(to_hour, to_min, from_min_day/60,from_min_day%60)
    #     # Antes esta frist_part, despues esta last_part y en medio el tiempo del TimeSheetHour
    #     unless last_part < 0 || first_part < 0 then
    #       if last_part>first_part && last_part > 35 && first_part < 35 then
    #         hole << [from_min_day,to_min_day-last_part]
    #       elsif last_part<first_part && first_part > 35 && last_part < 35 then
    #         hole << [from_min_day+first_part,to_min_day]
    #       elsif last_part > 35 && first_part > 35 then
    #         hole << [from_min_day,to_min_day-last_part]
    #         hole << [from_min_day+first_part,to_min_day]
    #       end
    #     end
    #   end
    #   hole
    # end

    #####################################################################
    # Prerequisitos:                                                    #
    #           1) parámetros del tipo entero.                          #
    # parámetros:                                                       #
    #           to_hour - horario hasta usado truncado en horas         #
    #           to_min - horario hasta usado, minutos complementarios   #
    #           from_hour - horario desde usado truncado en horas       #
    #           from_min - horario desde usado, minutos complementarios #
    # Devolución:                                                       #
    #           Entero indicando los minutos entre from_hour:from_min y #
    #           to_hour:to_min.                                         #
    #####################################################################
    def delta(to_hour, to_min, from_hour, from_min)
      y=2000
      m=12
      d=31
      z="+00:00"
      (((
        Time.new(y, m, d, to_hour, to_min, 0, z) -
        Time.new(y, m, d, from_hour, from_min, 0, z)
      ).round)/1.minute).round
    end

    def hole_from_to_cron(from_min_day, to_min_day,class_room_institute,day_order)
      hole=Array.new
      a=TimeSheetHour.where(vacancy: Vacancy.find_by(class_room_institute: class_room_institute))
      time_sheet_hours=Array.new
      a.each do |t|
        unless t.from_hour == 0 && t.from_min == 0 && t.to_hour == 0 && t.to_min == 0 then
          time_sheet_hours << t
        end
      end#todos los horarios que ocupan tiempo en cada aula#
      w=days_week_available(class_room_institute)
      if w[day_order] then
        k=0
        while k<1440 do
          if from_min_day <= k && k < to_min_day then
            hole << nil
          else
            hole << -1
          end
          k+=1
        end
        time_sheet_hours.each do |time_sheet_hour|
          tw=hour_week(time_sheet_hour)
          if tw[day_order] then
            i=delta(time_sheet_hour.from_hour, time_sheet_hour.from_min,0,0)
            j=delta(time_sheet_hour.to_hour, time_sheet_hour.to_min,0,0)
            while i<j do
              hole[i]=time_sheet_hour.id
              i+=1
            end
          end
        end
      else
        hole=nil
      end
      hole
    end

    def nil_to_cron(mins)
      unless mins.nil? then
        i=0
        fmin=nil
        tmin=nil
        out=Array.new
        mins.each do |m|
          if m.nil? && fmin.nil? then
            fmin=i
          elsif !m.nil? && !fmin.nil? then
            out << [fmin,i]
            fmin=nil
          end
          i+=1
        end
        unless fmin.nil? then out << [fmin,mins.count] end
      end
      out
    end
end