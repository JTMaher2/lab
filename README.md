Find kachlikmatt on GitHub and fork lab.
Open in an editor of your choice

To create a new Mysql project, in the cmd line type:
rails new filename -d mysql

Using CMD line cd into your lab/house

Execute: rails g controller listings index
//This will create your listings controller with a route to index.

Find what was updated in your app/controller. Then add:
def index
  @listings = Listing.all
  end
  def show
    @listing = Listing.find(params[:id])
  end
  def new
    @listing = Listing.new
  end

To stop from having to get the parameters every time we make a method call:
private
  def listing_params
    params.require(:listing).permit(:address,:price,:description)
  end


In the command line now execute rake routes to see what rails has done

Now edit the view of your home page. please delete:
<a href="#">Find local Listings</a>
and replace it with:
<%= link_to 'Show all listings', controller: 'listings' %>

In app/view/listings/index input this code:
<h1>All Listings:</h1>

<table>
  <tr>
    <th>Address:</th>
    <th>Price:</th>
    <th>Description:</th>
  </tr>

  <% @listings.each do |listing| %>
    <tr>
      <td><%= listing.address %></td>
      <td><%= listing.price %></td>
      <td><%= listing.description %></td>
      <td><%= link_to 'Show',listing_path(listing) %> </td>
      <td><%= link_to 'Edit',edit_listing_path(listing) %> </td>
      <td><%= link_to 'Destroy', listing_path(listing),
              method: :delete,
              data: { confirm: 'Are you sure?' } %></td>
    </tr>
  <% end %>
</table>

Now in CMD prompt type: rails generate model Listing address:string price:string
  description:string time_stamp:timestamp
Once you have added that go into app/model/listing.rb and add:
has_many :comments, dependent: :destroy
  validates :address, presence: true,
  length: {minimum: 5}

Now you must migrate all this. CMD prompt: rake db:migrate


Now it is time to be able to add a listing. return to app/views/homepage/index
under show all listings add:
<%= link_to 'Create a new listing', new_listing_path %>

Then go back to app/controller/listings and add:

def edit
    @listing = Listing.find(params[:id])
  end
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy

    redirect_to listings_path
  end
  def create
    @listing = Listing.new(listing_params)

    if @listing.save
    redirect_to @listing
    else
      render 'new'
    end
  end
  def update
    @listing = Listing.find(params[:id])

    if @listing.update(listing_params)
      redirect_to @listing
    else
      render 'edit'
    end
  end


Go to app/views/listing create a new file and add:
<h1>New Listing</h1>

<%= render 'form' %>

<%= link_to 'Back', listings_path %>
Save this file in listings as: new.html.erb
Go to app/views/listing create a new file and add:
<p>
  <strong>Address:</strong>
  <%= @listing.address %>
</p>

<p>
  <strong>Price:</strong>
  <%= @listing.price %>
</p>
<p>
  <strong>Description:</strong>
  <%= @listing.description %>
</p>
<h2>Comments:</h2>
<%= render @listing.comments %>

<h2>Add a comment:</h2>
<%= render 'comments/form' %>

<%= link_to 'Edit', edit_listing_path(@listing) %> |
<%= link_to 'All Listings', listings_path %> |
<%= link_to 'Home', root_path %>

Save this file in listings as: show.html.erb

Now you must migrate all this. CMD prompt: rake db:migrate

Go into config/routes.rb
delete: get 'listings/index'
under get 'homepage/index' add:
resources :listings do
     resources :comments
   end

Create new file under app/views/listings

<%= form_for @listing do |f| %>

  <% if @listing.errors.any? %>
    <div id="error_explanation">
      <h2>
        <%= pluralize(@listing.errors.count, "error") %> prohibited
        this listing from being saved:
      </h2>
      <ul>
        <% @listing.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <p>
    <%= f.label :address %><br>
    <%= f.text_field :address %>
  </p>

  <p>
    <%= f.label :price %><br>
    <%= f.text_field :price %>
  </p>
 <p>
   <%= f.label :description %><br>
   <%= f.text_area :description %>
 </p>

  <p>
    <%= f.submit %>
  </p>

<% end %>

save it as _form.hmtl.erb

Create new file under app/views/listings
<h1>Edit Listing</h1>

<%= render 'form' %>

<%= link_to 'Back', listings_path %>

save it as edit.html.erb


Execute: rails g controller comments

 go to app/controller/comments and add:

  class CommentsController < ApplicationController
   def create
     @listing = Listing.find(params[:listing_id])
     @comment = @listing.comments.create(comment_params)
     redirect_to listing_path(@listing)
   end

   def destroy
     @listing = Listing.find(params[:listing_id])
     @comment = @listing.comments.find(params[:id])
     @comment.destroy
     redirect_to listing_path(@listing)
   end

   private
     def comment_params
       params.require(:comment).permit(:commenter, :body)
     end
   end

 This is what does all the work for you.

Create two new files to go into app/views/comments

<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>
<p>
  <%= link_to 'Destroy Comment', [comment.listing, comment],
               method: :delete,
               data: { confirm: 'Are you sure?' } %>
</p>

 save this as _comment.html.erb

 <%= form_for([@listing, @listing.comments.build]) do |f| %>
  <p>
    <%= f.label :commenter %><br>
    <%= f.text_field :commenter %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end %>

save this as _form.html.erb

Now create a model for comments using commenter:string body:text listing:references
After, update the database by migrating.

Complete.
