# Timebank application


Epoch is a time banking system that allows users to receive services using the currency of their time, which is earned by providing other users with their own services. Every hour of work for someone else is added to their time bank, which can be spent getting help from another user. 

Users sign up for the Epoch web app and act as both a provider and recipient. They list services they can provide as well as services they need. Users can offer to render a service wanted or request that a specific user help them. When a request is made, a text message alert is sent to the the user receiving the request. An exchange page is generated when a request is made and, once accepted, they receive each other's contact information. After service is rendered, this is confirmed on the site and the hour is transferred from the recipient to the provider's time bank. A text message alert is sent to the user at each of the 4 stages of the exchange process--when it is proposed, accepted, delivered, and confirmed. 

Epoch is hosted live at http://epochbank.herokuapp.com/

Contributors: Annie Pennell, James Bradley, Lyn Muldrow, and Steven Gordon

The Trello board, containing the plan and many requirements, can be viewed here: https://trello.com/b/HGREwhBv/time-bank-app

Overview of site flow, page contents, and views (service_requests/index uses AJAX):

![alt tag](http://i.imgur.com/8mzvFkU.png)

Models:

![alt tag](http://i.imgur.com/INUJdAr.png)

API used: Twilio

### User stories
- https://docs.google.com/document/d/1ZqpuQ5uVsqs7olI2RHK1VU9CkcYs1f01N6gUWco54_k/edit
- http://www.cram.com/flashcards/timebank-user-stories-5827205

## Scope:

MVP V1.0: Using Time Bank, users must be able to:
- Log in and log out securely, and sign up -- after all, this is a bank! :)
  a.Keep in mind Admin role (with Devise) which is needed for V1.1
- Create and edit your own profile that includes
  - Name
  - Email
  - Phone
  - Photo
  - Your location (City and Zipcode)
  - What services/skills you can offer
    - Text to describe your services for MVP
  - Calculated fields on the profile page:
    - See all the exchanges that you have been part of (either as provider or recipient) -- and the current status of each exchange (see below for lifecycle)
    - See your current balance of hours available
    - How many exchanges you’ve done and how many hours earned/spent. (Build some ‘credibility’ in the community this way)
- View profiles of one specific user -- to see what services they can offer
  - But do NOT show the specific exchanges other users have done or their activity feed for MVP
- Create a “Wanted Listing” that includes
  - Title
  - Description
  - Approximate duration (hours)
  - Timing (in narrative form) i.e., when this needs to happen
  - Location (in text)
- View all Wanted Listings 
- View a specific Wanted Listing
  - With “I can do that for you” button that triggers API
- View list of all service providers (i.e., all users)
  - in MVP, just list their names and their text description of services
- Negotiation over exchange details is off-site → provide phone # and email once an exchange is ACCEPTED (don’t show contact info when exchange is just PROPOSED -- to avoid the “creepy Annie” issue… :)
- Exchange page (both people involved, status of exchange)
- See own user’s account page
- Manage the lifecycle of an exchange, by approving each next step (e.g., Accept proposal, Delivery complete, Confirm exchange) -- on exchange page

Phase Two (Our stretch goal) V2: Using Time Bank, users should be able to:
- One exchange has_many comments → On-site negotiations rather than just give each other phone & email
- “Please help me” input form with more details for exchange page
- Show total # of hours exchanged for the whole site/community
- Let users remove as “completed” Service Requests without deleting them
- Categories of services on profile pages and on all-users-list
  - On user profile, allow categories (not just text description) of services you can offer, to allow for better searching and browsing
  - Browse services available from other users by category, not just by list of names
- Search functionality -- to find services, people, nearby people, etc.
- Ratings on services provided

Future V3 (OUT OF SCOPE FOR THIS PROJECT #2): Using Time Bank, users could be able to:
- Admin role with editing power
- Offer services to a particular user -- even if they have not posted a “Service Requested”
- Make timing of service wanted or exchange less text-y and more data-y and thus searchable/filterable
- Allow users to “reject” a proposal they don’t want (so they don’t have to see it anymore in the proposed list and also proposer knows it’s over…)
- Follow up with users when an exchange gets hung up for too long in one stage
- Send alerts to SP if there is a new Wanted post that matches your abilities
- Show recent activity to make the home page fresh & vibrant
- Get SMS text alerts in more situations and let users REPLY to SMS messages and have our site receive and process the reply (e.g., to confirm an exchange)
  - For when someone makes “Service Offer” to you
  - To confirm service
  - To confirm your phone number when you sign up

Life cycle of an exchange
  - PROPOSAL: There are two ways to initiate an exchange
    - “Recipient” (R) can post “Wanted” listing describing the service they want to receive
      - Then a “ Provider” (“P”) can look through the Service Requests and make an offer to the R. (“I can do it” button = PROPOSAL from SP to SR)
      - From a database perspective, this creates a new row in “Exchange” with status:Proposed, proposed_by:SP_id, and linked to Wanted listing id. (Or Proposal_type indicating where it started?)
    - Or SR can ask a particular SP to provide a service, without first posting a “Wanted” listing but rather by browsing the SPs (or even having a prior experience with the SP) and clicking a “Please help me” button on the SP’s profile page. (“Please help me” button = PROPOSAL from SR to SP)
      - From a database perspective, this also creates a new row in “Exchange” with status:Proposed, proposed_by:SR_id, provided_by:
      - For MVP, “naked” (empty) Exchange appears in P’s list.  Ideally, allow entry of more info.
  - ACCEPT: The counter-party (whoever did NOT propose the exchange) needs to ACCEPT the proposal.  Either SR or SP should be notified (ideally by SMS but otherwise on website) that they have a proposal waiting for their review.
    - If it was an “I can do it” PROPOSAL, the SR has to decide they want the service from this particular SP.
    - If it was a “Please help me” PROPOSAL, the SP has to agree they want to provide their service to this particular SR.
  - PLAN: After acceptance, the two users plan the details of the exchange.  This can be through comments on a page that shows the PROPOSAL and ACCEPTANCE and is only accessible (via authorization) to those two users.
  - DELIVER: After the service is delivered, the SP (who has the incentive to earn the hours) needs to indicate that the service was delivered and confirm the exact final number of hours.  SP needs to visit the website to do this.
  - CONFIRM: Once the SP indicates the service has been delivered, the SR has to confirm that this was done, and confirm that the number of hours is correct.
    - Ideally, the SR should get a text after SP states delivery has happened, so that SR knows to go back to the website to confirm -- or ideally reply to SMS text with text confirmation
    - Need process to deal with disagreements over Delivery and Confirmation (e.g., over exact number of hours, or if it happened yet) 


### Wishlist

There are so many more things we would have loved to add with more time (and hopefully some that we can still get to)! Here are some of them.

- Add portfolio picture option with Paperclip
- Have an input form for "Please help me"--we got this started but couldn't quite finish
- Allow for messaging between two users on an exchange page
- User can search for and view profiles and requests by category of service and location
- User ratings on services provided
- Admin role
- Allow for replying through text messages
- Map user search results
- Show recent activity on home page
- Allow users to "reject" a proposal
- Have a "hold hours" functionality to put a hold on hours while an exchange is between being accepted and finalized
- Show total count of a user's exchanges on their profile page
- Don't let user respond more than once to the same service request
- Convert GET methods to POST or PUT for all exchange actions that write to database; use form-for instead link/button
- Let users turn on/off their text alerts