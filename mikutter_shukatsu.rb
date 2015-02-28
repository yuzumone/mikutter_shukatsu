# -*- coding: utf-8 -*-

require 'time'

Plugin.create(:mikutter_shukatsu) do

  defactivity "shukatsu_info", "就活情報"

  time = Time.new

  # 12時間以内のツイート
  # マイナビ2016
  Service.primary.user_timeline(user_id: 149032533, include_rts: 1, count: [UserConfig[:profile_show_tweet_once], 200].min).next{ |tl|
    tl.each do |m|
      if time - m.message[:created] < 43200
        activity(:shukatsu_info, "@#{m.user[:idname]}: #{m.to_s}")
      end
    end
  }
  # リクナビ2016
  Service.primary.user_timeline(user_id: 2410875912, include_rts: 1, count: [UserConfig[:profile_show_tweet_once], 200].min).next{ |tl|
    tl.each do |m|
      if time - m.message[:created] < 43200
        activity(:shukatsu_info, "@#{m.user[:idname]}: #{m.to_s}")        
      end
    end
  }

  # 30分以内のツイート
  def next_info(time)
    time += 1800
    Reserver.new(time) {
      # マイナビ2016
      Service.primary.user_timeline(user_id: 149032533, include_rts: 1, count: [UserConfig[:profile_show_tweet_once], 200].min).next{ |tl|
        tl.each do |m|
          if time - m.message[:created] < 1800
            activity(:shukatsu_info, "@#{m.user[:idname]}: #{m.to_s}")
          end
        end
      }
      # リクナビ2016
      Service.primary.user_timeline(user_id: 2410875912, include_rts: 1, count: [UserConfig[:profile_show_tweet_once], 200].min).next{ |tl|
        tl.each do |m|
          if time - m.message[:created] < 1800
            activity(:shukatsu_info, "@#{m.user[:idname]}: #{m.to_s}")        
          end
        end
      }
      next_info(time)
    }
  end
  next_info(time)

end
