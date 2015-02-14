# All your configuration should happen inside configure block
Crafter.configure do

  # This are projects wide instructions
  add_platform({:platform => :ios, :deployment => 8.0})
  add_git_ignore
  duplicate_configurations({:adhoc => :release})

  # set of options, warnings, static analyser and anything else normal xcode treats as build options
  set_options %w(
    RUN_CLANG_STATIC_ANALYZER
    GCC_TREAT_WARNINGS_AS_ERRORS
  )

  set_build_settings({
    :'WARNING_CFLAGS' => %w(
    -Wall
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
