Pod::Spec.new do |s|
  s.name             = 'CJCollectionViewAdapter'
  s.version          = '0.1.5.1'
  s.summary          = 'Adapter Help To Make Using UICollectionView Easily.'
  s.description      = <<-DESC
Bridge UICollectionView DataSource And Delegate Into Each Section Module.
Provide Each Section A Simple Way To Have A Sticky|Separator|Inner Header|Footer.
                       DESC

  s.homepage         = 'https://github.com/cj1024/CJCollectionViewAdapter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cj1024' => 'jianchen1024@gmail.com' }
  s.source           = { :git => 'https://github.com/cj1024/CJCollectionViewAdapter.git', :tag => s.version.to_s }
  s.screenshots      = 'https://ftp.bmp.ovh/imgs/2020/12/a6fc4de3dfcabb6a.png'

  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |core|
    core.frameworks = 'UIKit'
    core.source_files = 'CJCollectionViewAdapter/Classes/Core/**/*'
    core.public_header_files = 'CJCollectionViewAdapter/Classes/Core/*.h'
    core.private_header_files = 'CJCollectionViewAdapter/Classes/Core/Private/*.h'
  end

  s.subspec 'Cell' do |cell|
    cell.frameworks = 'UIKit'
    cell.source_files = 'CJCollectionViewAdapter/Classes/Cell/**/*'
  end

  s.default_subspecs = 'Core'

end
