class WorkShiftsController < ApplicationController
  before_action :set_work_shift, only: [:show, :edit, :update, :close, :reopen]

  before_action :authenticate_user!

  def index
    @work_shifts = WorkShift.to_the(current_restaurant.id).order(:start_at)
  end

  def show
  end

  def new
    @work_shift = WorkShift.new
  end

  def edit
  end

  def create
    start_at = Time.current

    @work_shift = WorkShift.new(
      name: set_work_shift_name(start_at),
      start_at: start_at,
      restaurant_id: current_user.restaurant.id
    )

    respond_to do |format|
      if has_open_work_shift?
        @work_shift.errors.add(:work_shift, 'There is an open work shift, you need to close it first.')
        format.html { redirect_to work_shifts_path }
        format.json { render json: @work_shift.errors, status: :unprocessable_entity }
      else
        if @work_shift.save
          format.html { redirect_to work_shifts_path, notice: 'Work shift was successfully created.' }
          format.json { render :show, status: :created, location: @work_shift }
        else
          format.html { redirect_to work_shifts_path }
          format.json { render json: @work_shift.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update
    params[:work_shift].delete(:start_at)
    params[:work_shift].delete(:restaurant_id)

    respond_to do |format|
      if @work_shift.update(work_shift_params)
        format.html { redirect_to work_shifts_path, notice: 'Work shift was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_shift }
      else
        format.html { render :edit }
        format.json { render json: @work_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @work_shift.destroy
    respond_to do |format|
      format.html { redirect_to work_shifts_url, notice: 'Work shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def close
    @work_shift.close!
    respond_to do |format|
      format.html { redirect_to work_shifts_path, notice: 'Work shift was successfully closed.' }
      format.json { render :show, status: :ok, location: @work_shift }
    end
  end

  def reopen
    @work_shift.reopen!
    respond_to do |format|
      format.html { redirect_to work_shifts_path, notice: 'Work shift was successfully reopened.' }
      format.json { render :show, status: :ok, location: @work_shift }
    end
  end

  private

    def set_work_shift_name(time)
      if time.to_time >= "17:00:00".to_time || time.to_time < "04:00:00".to_time
        "Work Shift 03"
      elsif time >= "12:00:00".to_time
        "Work Shift 02"
      elsif time >= "04:00:00".to_time
        "Work Shift 01"
      end
    end

    def set_work_shift
      @work_shift = WorkShift.find(params[:id])
    end

    def work_shift_params
      params.require(:work_shift).permit(:name, :start_at, :end_at, :restaurant_id)
    end
end
