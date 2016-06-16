Handlebars.registerPartial( "tag", $( "#tag" ).html());

// posts data
var posts = [{
  title: "My Second Title",
  published: "16.4.2016",
  body: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."
}];

var post_data = {
  title: "My Title",
  published_date: "12.4.2016",
  body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
};

post_data.tags = ["Coding", "Travel", "Music"];
// add paragrapgh tags to body
post_data.body = "<p>" + post_data.body + "</p>";

// add single post to post array
posts.push(post_data);

// create posts template
var posts_template = Handlebars.compile($( "#post-template" ).html());

// append the result of running the posts array through the template
$( "#posts" ).append(posts_template({ posts: posts }));
