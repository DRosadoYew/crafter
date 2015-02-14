How do you setup your Cocoa projects? Do you always set same warnings, clone configurations and do bunch of other stuff? Or maybe you work in a big company and you are missing some standardised setup? 

Programmers tend to automatise boring and repetitive tasks, yet I often see people spending time and time again configuring their Xcode Projects, even thought they always set it up same way. 

We all know that Xcode templating system is far from perfect, beside we often use different templates, but same level of warnings, scripts etc.

What if you could define your project setup once (even with optional stuff) then just apply that to all your projects?

## Enter crafter
That's why I've created **crafter**, a ruby gem that you can install, setup your configuration once and enjoy hours of time saved.

### So how does it work?
Install it by calling:
```
gem install crafter
crafter reset
```
this will create your personal configuration file at **~/.crafter.rb**

now open that file with your favourite editor and you will see default configuration, along with description of different parts:


```ruby
load "#{Crafter::ROOT}/config/default_scripts.rb"

# All your configuration should happen inside configure block
Crafter.configure do

  # This are projects wide instructions
  add_platform({:platform => :ios, :deployment => 7.0})
  add_git_ignore
  duplicate_configurations({:adhoc => :release})

  # set of options, warnings, static analyser and anything else normal xcode treats as build options
  set_options %w(
    RUN_CLANG_STATIC_ANALYZER
    GCC_TREAT_WARNINGS_AS_ERRORS
  )

  set_build_settings({
    :'WARNING_CFLAGS' => %w(
    -Weverything
    -Wno-objc-missing-property-synthesis
    -Wno-unused-macros
    -Wno-disabled-macro-expansion
    -Wno-gnu-statement-expression
    -Wno-language-extension-token
    -Wno-overriding-method-mismatch
    ).join(" ")
  })

  set_build_settings({
    :'BUNDLE_ID_SUFFIX' => '.dev',
    :'BUNDLE_DISPLAY_NAME_SUFFIX' => 'dev',
    :'KZBEnv' => 'QA'
  }, configuration: :debug)

  set_build_settings({
    :'BUNDLE_ID_SUFFIX' => '.adhoc',
    :'BUNDLE_DISPLAY_NAME_SUFFIX' => 'adhoc',
    :'KZBEnv' => 'QA'
  }, configuration: :adhoc)

  set_build_settings({
    :'BUNDLE_ID_SUFFIX' => '',
    :'BUNDLE_DISPLAY_NAME_SUFFIX' => '',
    :'KZBEnv' => 'PRODUCTION'
  }, configuration: :release)

  # CUSTOM: Modify plist file to include suffix and displayname
  # CUSTOM: Add empty KZBootstrapUserMacros.h file to your project and .gitignore
  # CUSTOM: Add KZBEnvironments.plist with list of your environments under KZBEnvironments key

  # target specific options, :default is just a name for you, feel free to call it whatever you like
  with :default do

    # each target have set of pods
    pods << %w(KZAsserts KZBootstrap KZBootstrap/Logging KZBootstrap/Debug)

    # add build script for bootstrap
    scripts << {:name => 'KZBootstrap setup', :script => '"${SRCROOT}/Pods/KZBootstrap/Pod/Assets/Scripts/bootstrap.sh"'}

  end
end
```

As you can see the configuration files is quite easy, yet is pretty flexible.
Once you set it up as you see fit, go to your project folder (the one with xcodeproj, workspace etc.) and call:

```bash
crafter
```

it will guide you through project setup, with default configuration it would look like this:
```bash
1. sample
2. sampleTests
Which target should I use for default?
1
1. sample
2. sampleTests
Which target should I use for tests?
2
do you want to add networking? [Yn]
n
do you want to add coredata? [Yn]
y
do you want to add testing? [Yn]
n
duplicating configurations
setting up variety of options
preparing git ignore
preparing pod file
adding scripts
Finished.
```

Now your project should have all options applied, generated Podfile (call pod install or set it up in your configuration).

I'm learning Ruby, so I'm looking forward to pull requests on [GitHub][5]

Send me your thoughts, I'm [merowing_ on twitter][7]

#### Acknowledgements:

[The App Business][1] (the company I worked for) for supporting my idea.

to [@alloy][2], [@orta][3], [@romainbriche][4] - for taking some of their valuable time and sharing their thoughts about beta version.

Inspired by [liftoff][6]

 [1]: http://theappbusiness.com
 [2]: http://twitter.com/alloy
 [3]: http://twitter.com/orta
 [4]: http://twitter.com/romainbriche
 [5]: https://github.com/krzysztofzablocki/crafter
 [6]: https://github.com/thoughtbot/liftoff
 [7]: http://twitter.com/merowing_
