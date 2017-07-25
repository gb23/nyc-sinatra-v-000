class FiguresController < ApplicationController

    get '/figures' do
        @figures = Figure.all 
        erb :'figures/index'
    end

    get '/figures/new' do
        @titles = Title.all
        @landmarks = Landmark.all
        erb :'figures/new'
    end

    post '/figures' do
    
        figure = Figure.create(params[:figure])
        figure.titles.create(params[:title]) if !params[:title][:name].empty?
        figure.landmarks.create(params[:landmark]) if !params[:landmark][:name].empty?
        
        redirect to "/figures/#{figure.id}"
    end

    get "/figures/:id" do
        @figure = Figure.find(params[:id])
        erb :'figures/show'
    end
    
    get "/figures/:id/edit" do
         @figure = Figure.find(params[:id])
         @landmarks = Landmark.all
         @titles = Title.all
         erb :'figures/edit'
    end
    
    patch '/figures/:id' do
        figure = Figure.find(params[:id])
        figure.update(name: params[:figure][:name])
       
        figure.landmarks = []
        figure.titles = []

        if params[:figure][:landmark_ids]
            params[:figure][:landmark_ids].each do |lm_id|
                figure.landmarks << Landmark.find_or_create_by(id: lm_id.to_i)
            end
        end

        if params[:figure][:title_ids]
            params[:figure][:title_ids].each do |title_id|
                figure.titles << Title.find_or_create_by(id: title_id.to_i)
            end

        end

        title = Title.find_or_create_by(params[:title]) if !params[:title][:name].empty?
        landmark = Landmark.find_or_create_by(params[:landmark]) if !params[:landmark][:name].empty?

        figure.titles << title if title
        figure.landmarks << landmark if landmark

        redirect to "/figures/#{figure.id}"
      
    end    
end

# Nested Hash structure
    #  params => {
    #     figure =>{
    #         name => _____,
    #         title_ids => [_,_,_,],
    #         landmark_ids => [_,_,_],
    #     },
    #     landmark =>{
    #         name=> _______
    #     }
    #     title =>{
    #         name=> _______
    #     }
    # } 