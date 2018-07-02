class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
          :type => "buttons",
          :buttons => ["로또", "메뉴", "고양이","맛집"]
    }
    render json: @keyboard
    
  end
  
  def message
    @user_msg = params[:content]
    @text = "기본 텍스트"
    if @user_msg == "로또"
       #@text = [1,2,3,4,5,6].sample.to_s
       @text = "행운의 번호는 " +  (1..45).to_a.sample(6).to_s + "입니다."
    
    elsif @user_msg == "메뉴"
       @text = ["20층","김밥까페"].sample 
    
    elsif @user_msg == "고양이"
       @url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
       @cat_xml = RestClient.get(@url)
       @cat_doc = Nokogiri::XML(@cat_xml)
       @cat_url = @cat_doc.xpath("//url").text
      # @text = @cat_url
 
    end
    
    
   
    # 전체 객체의 메시지 타입. 
    @return_msg = {
      :text => @text
    }
    @return_msg_photo = {
      :text =>"나만 고양이 없어 :(",
      :photo =>{
        :url => @cat_url,
        :width => 720,
        :height => 630
      }
    }
    @return_url = {
      :message_button => {
        :label => "라벨입니다 ",
        :url  => "http://www.mcdonalds.co.kr/www/kor/findus/district.do"
    }
    }
    
    
    
    @return_result = {
      :url => @url
    }
    @return_keyboard = {
          :type => "buttons",
          :buttons => ["로또", "메뉴", "고양이","맛집"]
    }
    if @user_msg == "고양이"
      @result = {
        :message => @return_msg_photo,
        :keyboard => @return_keyboard
      }
    elsif @user_msg == "맛집"
      @result = {
        :message => @return_url,
        :keyboard => @return_keyboard
      }
    else    
      @result = {
        :message => @return_msg,
        :keyboard => @return_keyboard
      }
    end
    

    
    render json: @result
    
  end
end
