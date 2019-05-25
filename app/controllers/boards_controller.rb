class BoardsController < ApplicationController
	# %iはシンボルの配列を定義  => [:Ruby, :Python, :PHP]
  # before_action :set_target_board, only: [:show, :edit, :update, :destroy]
  before_action :set_target_board, only: %i[show edit update destroy]

	def index
    # @baords以下、三項演算子を使用
    @boards = params[:tag_id].present? ? Tag.find(params[:tag_id]).boards : Board.all
		@boards = @boards.page(params[:page])
	end

	def new
		#flash[:board]で値を返してセットする役割をもつ。
		@board = Board.new(flash[:board])
	end

	def create
		board = Board.new(board_params)
		if board.save
			# boards/idにリダイレクト
			flash[:notice ] = "「#{board.title}」の掲示板を作成しました。"
			redirect_to board
		else
			# boardオブジェクトとエラーメッセージを返す boardオブジェクトを返すのは、
			# 入力した値が消えないために、boardオブジェクトを返している。
			redirect_to new_board_path, flash: { board: board, error_messages: board.errors.full_messages }
		end
	end

	def show
    # associationの設定
    #@board.idに紐づいたidを設定する
    # NG:@comment = @board.comments.new => 新しく作成された保存されているいない
    #コメントが@borad.commentsにふくまれてしまう=>常にからのコメントが表示されてしまう
    @comment = Comment.new(board_id: @board.id)
	end

	def edit
		#/boards/:id/edit
	end

	def update
		#/boards/:id
		# インスタンス変数ではなく、ローカル変数
		#viewに表示せず、viewに値を渡す必要がないため
		if @board.update(board_params)
		#board はオブジェクト指定で値をリダイレクトする → redirect先 boards/:id
		#掲示板の詳細に遷移する
		  redirect_to @board
    else
      flash[:board] = @board
      flash[:error_messages] = @board.errors.full_messages
      redirect_back fallback_location: @board
    end
	end

  def destroy
    # delteteからdestroyへコメントを削除したさい、タグの関連づけのデータも一緒に削除
    #dependent: :delete_allをrbに設定していることが前提
		@board.destroy
		redirect_to boards_path, flash: { notice: "「#{@board.title}」の掲示板を削除しました"}
  end

	private
	# strong parameters
	  def board_params
      # tag_ids: [] 複数のidで配列が渡って来るため、[]で記載
			params.require(:board).permit(:name, :title, :body, tag_ids: [])
		end

		def set_target_board
				@board = Board.find(params[:id])
		end
end
