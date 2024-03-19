# frozen_string_literal: true

class BlogsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_blog, only: %i[show edit update destroy]
  before_action :your_blog, only: %i[edit update destroy]

  def index
    @blogs = Blog.search(params[:term]).published.default_order
  end

  def show; end

  def new
    @blog = Blog.new
  end

  def edit; end

  def create
    @blog = current_user.blogs.new(blog_params)

    if @blog.save
      redirect_to blog_url(@blog), notice: 'Blog was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      redirect_to blog_url(@blog), notice: 'Blog was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy!

    redirect_to blogs_url, notice: 'Blog was successfully destroyed.', status: :see_other
  end

  private

  def set_blog
    @blog = if current_user.nil?
      Blog.where(secret: false).find(params[:id])
    else
      blog = Blog.find(params[:id])
      blog.secret ? current_user.blogs.find(params[:id]) : Blog.find(params[:id])
    end
  end

  def your_blog
    @blog = current_user.blogs.find(params[:id]) unless @blog.user == current_user
  end

  def blog_params
    keys = [:title, :content, :secret]
    keys.push(:random_eyecatch) if current_user.premium
    params.require(:blog).permit(*keys)
  end
end
