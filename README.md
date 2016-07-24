Apple Store API
REST API application that pulls the Apple App Store top lists from US and provides additional metadata information for each of the ids returned via Apple lookup API together with a simple aggregation functionality.

Routes implemented:

## Top apps for a given category and monetization.

http://localhost:3000/api/v1/categories/top_apps?category_id=6011&monetization=free

```
{ "response":
  [
    { "apple_store_id": 284035177,
  	  "metadata" : {  "price" : 0.0,
                      "app_name" : "Pandora - Free Music \u0026 Radio",
                      "description" : "Pandora will change the way you discover and listen to music....",
                      "version_number" : "7.4.1",
                      "publisher_name" : "Pandora Media, Inc.",
                      "publisher_id":284035180,
                      "small_icon_url":"http://is1.mzstatic.com/image/thumb/Purple30/v4/bd/65/12/bd651282-41e5-9ede-557b-e69d71984eb0/source/60x60bb.jpg",
                      "average_user_rating":4.0 }
    },
    { "apple_store_id" : 324684580, 
      "metadata" : {  "price" : 0.0,
                      "app_name" : "Spotify Music",
                      "description" : "Spotify is the best way to listen to music on mobile or tablet.....",
                      "version_number" : "5.7.0",
                      "publisher_name" : "Spotify Ltd.",
                      "publisher_id" : 324684583,
                      "small_icon_url" : "http://is2.mzstatic.com/image/thumb/Purple60/v4/06/09/43/06094359-4643-7854-0e13-ec6f6c241ff3/source/60x60bb.jpg",
                      "average_user_rating" : 4.5}
    }
  ]
}
```

### Ranking of publishers for a given category and monetization, ordered by ranking position.


http://localhost:3000/api/v1/categories/publishers_ranking?category_id=6011&monetization=free

```
{ "response" : [
    { "app_names" : [ "Magic Piano by Smule","Sing! Karaoke by Smule","AutoRap by Smule","Guitar! by Smule" ],
      "publisher_id" : 290596339,
      "publisher_name" : "Smule",
      "number_of_apps" : 4,
      "ranking_position" : 1 
    },
    { "app_names" : ["Trap Drum Pads 24","Drum Pads 24 - Make beats and music","Dubstep Drum Pads 24 - Make Beats And Music!","Hip-Hop Drum Pads 24"],
      "publisher_id" : 667945911,
      "publisher_name" : "Paul Lipnyagov",
      "number_of_apps" : 4,
      "ranking_position" : 2
    },
    { "app_names" : ["Real Guitar Free - The Ultimate Guitar Game App: Acoustic and Electric Guitars, Chords, Tabs, Songs and more!"],
      "publisher_id" : 666830030,
      "publisher_name" : "Gismart",
      "number_of_apps":3,
      "ranking_position":3
    }
  ]
}
```

### App by ranking position

http://localhost:3000/api/v1/categories/app_by_ranking_position?category_id=6011&rank_position=2&monetization=free

```
{ "response" : 
  [
    { "apple_store_id" : 284035177,
      "metadata" : 
        {
          "price" : 0.0,
          "app_name" : "Pandora - Free Music Radio",
          "description" : "Pandora will change the way you discover and listen to music....",
          "version_number": "7.4.1",
          "publisher_name" : "Pandora Media, Inc.",
          "publisher_id" : 284035180,
          "small_icon_url":"http://is1.mzstatic.com/image/thumb/Purple30/v4/bd/65/12/bd651282-41e5-9ede-557b-e69d71984eb0/source/60x60bb.jpg",
          "average_user_rating":4.0
        }
    }
  ]
}
```
