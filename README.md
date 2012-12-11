marshmallow
===========

## What does it do?

Takes Campfire event data via HTTP, saves it in redis and serves it up as CSV.

Preliminary version (tests require local redis and pollute it when run).

## How do I send events from Java?

Send a POST as per android documentation:

```java
HttpClient client = new DefaultHttpClient();
HttpPost post = new HttpPost("http://marshmallow.herokuapp.com/events/add");
try {
  List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>(2);
  nameValuePairs.add(new BasicNameValuePair("timestamp", String.valueOf(System.currentTimeMillis())));
  nameValuePairs.add(new BasicNameValuePair("some_name", " some value"));
  post.setEntity(new UrlEncodedFormEntity(nameValuePairs));
  HttpResponse response = client.execute(post);
```