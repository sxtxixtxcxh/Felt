Meteor.publish "users", ()->
  return Meteor.users.find({})

Meteor.publish "cards", (deckId)->
  Cards.find({deck: deckId}, sort:{createdAt: 1})

Meteor.publish "decks", (userId)->
  Decks.find({users: userId})
  Decks.find({})
