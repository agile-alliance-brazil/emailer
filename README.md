# emailer

A small CLI to email a CSV of data set with an agile brazil session id with a markdown template email and a css file.

## How to run

This is a simple ruby CLI application. Running it is simply invoking the main file once all dependencies are installed

### Setup

Install [ruby 2.4.3](https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.3.tar.gz).

Then install bundler (`gem install bundler`) and then run `bundle install` to get all dependencies.

Copy the [`.env.example`](.env.example) file to `.env` and replace the content with your valid AWS credentials and server preference
as well as your sender email that is registered with your AWS SES account.

### Running the CLI

Then run:

```bash
bundle exec ruby lib/mail.rb "subject" data/email_template.md data/data_set.csv data/email_style_to_inline.css --bcc optional@bcc.copy.com,other@optional.bcc.com
```

The email_template can include ERB style markups (`<%= a_variable %>`) as well as html markups (`<span style="color: yellow">Text</span>`).

The data set should include at least a column called `email`. All other columns will be mapped to variables that can be used both in the
subject text or the email template.

#### Example

With a data set saved in `data/data_set.csv` such as:

```csv
email,hero,alterego,years
tony@stark.com,Iron Man,Tony Stark,4
superman@dailyplanet.com,Superman,Clark Kent,20
spidy@stark.com,Spider man,Peter Parker,1
```

And an email template saved in `data/email_template.md` as:

```markdown
Hello <%= alterego %>,


### Happy aniversary! ###


We're very please to announce that your secret identity for <%= hero %> has been safe with us for now *<%= years %>* years!

As we know how **important** it is to keep your identity safe, we are happy you have trusted us with such _secret_.


Truthfully yours,

Multiverse heroes data store
```

And finally a css file saved in `data/email_style_to_inline.css` as:

```css
h3 {
    text-transform: uppercase;
    color: blue;
}
```

We can then run:

```bash
bundle exec ruby lib/mail.rb "Thank you for your business <%= hero %>" data/email_template.md data/data_set.csv data/email_style_to_inline.css --bcc heroesdb@multiverse.com
```

This would email Iron Man, Superman and Spider man on the provided emails, with a bcc for `heroesdb@multiverse.com` on a subject that would fill, for example, for Iron Man, as `Thank you for your business Iron Man` and a body in plain text that would match:

```
Hello Tony Stark,


### Happy aniversary! ###


We're very please to announce that your secret identity for Iron Man has been safe with us for now *4* years!

As we know how **important** it is to keep your identity safe, we are happy you have trusted us with such _secret_.


Truthfully yours,

Multiverse heroes data store
```

And an html version:

```
<p>Hello Tony Stark,</p>

<h3 style='text-transform:uppercase;color:blue;'>Happy aniversary!</h3>

<p>We&#39;re very please to announce that your secret identity for Iron Man has been safe with us for now <em>4</em> years!</p>

<p>As we know how <strong>important</strong> it is to keep your identity safe, we are happy you have trusted us with such <em>secret</em>.</p>

<p>Truthfully yours,</p>

<p>Multiverse heroes data store</p>
```