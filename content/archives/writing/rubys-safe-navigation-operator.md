# Ruby's Safe Navigation Operator

I was recently working on a Ruby project and coworker had never used the safe navigation operator in Ruby so I thought I'd write about it.


## Scenario

Imagine you have a blog_post which has an owner who has a name and you want to get the name of owner. You could write the following code:

```ruby
  name = blog_post.owner.name
```
  
Although, what if the blog_post or owner is nil? Ruby would raise an exception: NoMethodError (undefined method for nil:NilClass). To avoid 
this you could rewrite the above code like this:


```ruby
  if blog_post && blog_post.owner
    name = blog_post.owner.name
  end
```

Although safer it can quickly get annoying to be that verbose every time we need to chain method calls.


## The Safe Navigation Operator (&.)

Introduced in Ruby 2.3.0, we now have succinct way to safely chain method calls. Taking the example from above we can rewrite it like this:

```ruby
  name = blog_post&.owner&.name
```

## Gotchas

The safe navigation operator only guards against nil objects. It doesn't give you the ability to blindly call any method on objects. For example:

```ruby
  nil&.foo
  #=> nil

  "string"&.foo
  #=> NoMethodError (undefined method `foo' for "string":String)
```
  
*Published on March 21, 2019*
