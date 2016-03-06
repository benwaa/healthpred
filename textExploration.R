

temp <- clean.text(c("Wow, good thread. I'll have to be sure to find it when I do the other knee. My blues often hit during PT and also in the evening. Several times while trying to do an exercise or stretch, the tears would start streaming. I was frustrated - at being in recovery again, at not being able to work hard for my normalcy, at having to be patient when I just wanted to be better. The PTs, all men, would get a little panicky when I cried and back off the exercises, well a bit. The other common time for the blues to hit was in the evening. I started work from home week 2 after surgery, so I got to work full days just 7 days our of surgery. By the end of the 1st work day, I knew I had made a mistake but didn't really think I could turn back. Most evenings, I was too tired to do anything, even talk to the people who were caring for me. That passed quicker than the PT blues but it was harder because I knew how it made them feel. I was just so tired. 

I overcame the PT blues by taking more control and a kinder, gentler approach to my recovery. This forum led me to me realize that the thing to help my recovery was something I had little control over, time. Add a cup, no, a vat of patience to the looooonnnnnnnggggggg, slooooooooooow recovery and I soon learned to give myself a break. I also learned to tell others to give me a break. No matter how good I looked on the outside, I was dragging on the inside and every single thing I accomplished in the 1st 3 months took about 4 times more energy than if everything was healed. Some days I still get blue when I think about my other knee.
The loss of control was huge for me. My BFF and I were just remembering something that happened this time two years ago. It was another very cold day, she was driving me to Drs. Appts in my car, upon trying to fill it up the little door to the gas tank wouldn't open. I lost it! Yelling at her! I felt bad as soon as I did it and still feel terrible about it. But I had no control, over my leg, my life, my car, I hadn't driven in over 2 months because I couldn't bend my knee. 
So sometimes depression and anxiety go hand in hand. Not at all looking forward to the other knee.",
"On a practical note, I found that reading ( while elevating and icing for hours on end!) helped
( Remember the old Calgon ads? ) I love , so I downloaded every mindless book set in France that I could find. I escaped into my Kindle and emerged refreshed and somewhat calmed. Knowing that a successful surgery and recovery means a return to France able to walk pain free encouraged me to stick to the course. Indulge in your. It will give you an escape from the constant thought/worry about your knee. 
Since my surgery was in July, I also spent a lot of time looking at the incision. It has been a relief to cover it up this fall/ winter with long pants! Out of sight, out of mind?",

"Hello fellow travelers, tonight I was hesitant to type in the word depression in the search bar for fear I would become even more depressed. This thread is very timely. I am 12 weeks post op tomorrow and this discussion couldnt come at a better time. I am still crying everyday, tonight I am worried that I wont get better, that there is something wrong with me, I have a lot of anxiety, perhaps more anxiety than depression but it just seems I should be used to the fact that this is a slow process. Part of my problem is I'm very competitive and the fact that I dont have full extension or good flexion yet is driving me crazy. I had a very busy weekend so I know that is part of my problem tonight. I know rationally what is going on but I just seem to fall apart at least once a day. i feel very disappointed in myself. I feel weak, it's not who I want to be or how I want to recover. My nasty little control issue raises its head once again. I am just so tired of feeling down. I am considering getting some antidepressants.",

"I warned my husband that post-op blues was a normal part of recovery, so when it hit, I was able to say, Here  And he knew what I meant and was able to listen and hug as required. He was also able to provide reassurance about whatever my concerns were.",
"The depression was very real for me. I have been dealing with major depression on and off my entire life and this recovery has been difficult to go through especially when I felt alone. Everyone here has been a tremendous help to me.",
"Seriously though it is incredibly frustrating that they can't really work it out. Although I am accused of being a (stand by my overseas friends, a spot of colloquial coming up) nazzbag (which comes out as ) it's because they dont pick up on what we perceive as The Obvious :yawn: ie we are fretting over whats to come; we are very tired as we dont sleep very well and are actually in pain pretty much most of the time (but dont bother to say, mostly because it would be, well, boring) AND we are actually quite frightened. 

And they dont really understand priorities.....
For instance this evening we had people over for supper. It was organised yonks ago and I didn't want to cancel as we owed both sets of friends as they had hosted us more than once. I explained yesterday to hubby that I would need help as Prepping would mean lots of time on my feet and he readily said he'd Hoover, lay the table, peel the veg, etc etc. I got on with stuff and he appeared and clogged up the kitchen making bread. We didn't even need bread! :hairpulling:
In bed now. Very tired and aching - that's my Saturday night Sunday rant over with. ")
)

corpus = Corpus(VectorSource(temp))
# create document term matrix applying some transformations
tdm = TermDocumentMatrix(corpus, control = list(
  removePunctuation = TRUE, 
  stopwords = c(stopwords("english"), "said","just"),
  removeNumbers = TRUE, tolower = TRUE))
# convert as matrix
m = as.matrix(tdm)

# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"), max.words = 150)












# UNUSED MAP SHIT
# library(RCurl)
# library(RJSONIO)
# library(plyr)
# url <- function(address, return.call = "json", sensor = "false") {
#   root <- "http://maps.google.com/maps/api/geocode/"
#   u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
#   return(URLencode(u))
# }
# 
# geoCode <- function(address,verbose=FALSE) {
#   if(verbose) cat(address,"\n")
#   u <- url(address)
#   doc <- getURL(u)
#   x <- fromJSON(doc,simplify = FALSE)
#   if(x$status=="OK") {
#     lat <- x$results[[1]]$geometry$location$lat
#     lng <- x$results[[1]]$geometry$location$lng
#     location_type <- x$results[[1]]$geometry$location_type
#     formatted_address <- x$results[[1]]$formatted_address
#     return(c(lat, lng, location_type, formatted_address))
#   } else {
#     return(c(NA,NA,NA, NA))
#   }
# }
# 
