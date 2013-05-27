## Experimenting with form objects in Rails

I was playing with form objects as discussed here:

* http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
* http://robots.thoughtbot.com/post/33296680513/activemodel-form-objects
* http://pivotallabs.com/form-backing-objects-for-fun-and-profit/

I'm still clinging to the notion that models often need do a certain
amount of validation before they hit the database. (I'm also in the
camp that likes foreign-key, uniqueness, and not-null constraints
in the database, even though the accepted Rails wisdom is that
validations are enough.)

This is an experiment with two goals:

* to try out whether it's reasonable for a form object to let the
underlying object do some validation, while adding additional
validation of its own; and

* to try to abstract common form-object behavior out of the object
(since I was seeing the same boilerplate in many of the examples,
and I didn't want all my form objects to have to include e.g. the
magic ```def persisted; false; end``` incantation). (This was my
first real experimentation with ActiveModel, too.)

### Validations

A form object is an encapsulation: it takes responsibility for
hiding the model details from the view. As part of that responsibility,
it needs to ensure either that whatever data it uses to initialize
the underlying models meets those models' validation requirements,
or that validation errors on the models are passed through to the
view in a useful way.

The former smells of duplication (and brittle coupling) to manually
duplicate model validations on the form object. Instead, I tried
to make the latter work: the form object validates itself as well
as its model objects. When validation fails on any of the models,
the form object can either take responsibility for adding errors
to its own attributes, or they'll be copied from the model to
```:base``` on the form object's ```errors```.

### Abstracting out common behavior

When I started this, I chose to create a base class to inherit from;
after getting everything working, I tried to convert it to a module
(using ActiveSupport::Concern), but ran into difficulty with getting
```super``` to do the right thing; for now, I've left this alone.
