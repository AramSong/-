# 카카오톡 챗봇

루비에서 해쉬를 쓰는 방법

1)  "key" => "value",

2)  :key => "value",

3)  key:  "value"

#### post - http(s)://server_url/message

```
-result(hash)
	-message(json)
		-text	: string
		-photo(json)
		-message_button(json)
	-keyboard(json)
		-type : string(text,buttons)
		-buttons : Array ["로또","메뉴","고양이"]
```

* photo

`http://thecatapi.com/api/images/get?format=xml&type=jpg`

* rest-client : 요청을 받아온다
* nokogiri : 특정한 문서형태를 조금 쉽게 접근이 가능하도록 하는 것

```ruby
   elsif @user_msg == "고양이"
       @url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
       @cat_xml = RestClient.get(@url)
       @cat_doc = Nokogiri::XML(@cat_xml)
       @cat_url = @cat_doc.xpath("//url").text
       @text = @cat_url
    end
```

1. API형 플러스 친구
2.  c9에서 컨트롤러를 만들어 준다.

`rails g controller kakako keyboard message`

3. `app/controller/kakao_controller.rb`키보드 생성

```ruby
class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
      :type => "buttons",						# 이렇게 작성해도
      buttons: ["선택 1", "선택 2", "선택 3"]		 # 요렇게 작성해도 똑같습니다.
    }
    render json: @keyboard
  end

  def message
  end
end
```

4. `config/routes/rb`플러스친구 라우팅 추가

```ruby
get '/keyboard' => 'kakao#keyboard'
```

5. 카카오 플러스친구 관리자센터에서 API테스트로 확인
6. 시작하기 버튼을 통해 채팅 활성화
7. message 추가
8. `config/routes.rb`

```ruby
post '/message' => 'kakao#message'
```

9. `app/controller/kakao_controller.rb`사용자가 보낸 메세지를 parameter로 받아온다.

```ruby
def message
    @user_msg = params[:content] #사용자가 보낸 내용은 content에 담아서 전송
end
```

10. `app/controller/applicatio_controller.rb` 주석처리

```ruby
#protect_from forgery with :exception
```

11. `kakao_cotroller.rb` 

```ruby
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

```

* Message :  카카오톡 이용자가 명령어를 선택 혹은 입력했을 때 이용자에게 전송하는 응답 메세지.  String,photo, MessageButton조합으로 이루어진다.

