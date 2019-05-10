#!/usr/bin/env ruby

require 'bundler/setup'
require 'colorize'
require 'digest'

# TODO
#  * check namespace name in 00-namespace.yaml matches directory name
#  * check all required fields have plausible values

YAML_FILES = [
  '00-namespace.yaml',
  '01-rbac.yaml',
  '02-limitrange.yaml',
  '03-resourcequota.yaml',
  '04-networkpolicy.yaml'
]

# md5sum of the standard main.tf file
MAIN_TF_MD5 = '3049b2f652c1e04ddf44a0ec05f47a64'

class NamespaceChecker
  attr_reader :namespace, :report

  def initialize(args)
    @namespace = args.fetch(:namespace)
    @report = args.fetch(:report, Report.new)
  end

  def run
    check_directory
    report.output
  end

  private

  def check_directory
    dir = "namespaces/live-1.cloud-platform.service.justice.gov.uk/#{namespace}"
    if is_dir?(dir)
      check_yaml_files(dir)
    end

    resources_dir = "#{dir}/resources"

    if is_dir?(resources_dir)
      check_main_tf(resources_dir)
    end
  end

  def check_yaml_files(dir)
    YAML_FILES.each do |f|
      filename = "#{dir}/#{f}"
      is_file?(filename)
    end
  end

  def check_main_tf(dir)
    filename = "#{dir}/main.tf"
    if is_file?(filename)
      if Digest::MD5.hexdigest(File.read(filename)) == MAIN_TF_MD5
        report.add_pass("#{filename} MD5 matches expected")
      else
        report.add_warning("#{filename} MD5 does not match expected")
      end
    end
  end

  def is_dir?(dir)
    FileTest.directory?(dir) ? report.add_pass("#{dir} is a directory") : report.add_fail("#{dir} is not a directory")
  end

  def is_file?(file)
    FileTest.exists?(file) ? report.add_pass("#{file} exists") : report.add_fail("#{file} does not exist")
  end
end

class Report
  attr_reader :passes, :fails, :warnings

  def initialize
    @passes = []
    @fails = []
    @warnings = []
  end

  def add_pass(msg)
    @passes << msg
    true
  end

  def add_fail(msg)
    @fails << msg
    false
  end

  def add_warning(msg)
    @warnings << msg
    false
  end

  def output
    if @passes.any?
      @passes.each {|p| puts "  #{p}".green}
      puts
    end

    if @fails.any?
      @fails.each {|f| puts "  #{f}".red}
      puts
    end

    if @warnings.any?
      @warnings.each {|w| puts "  #{w}".yellow}
      puts
    end

    puts "#{@passes.count} PASSES"
    puts "#{@fails.count} FAILS"
    puts "#{@warnings.count} WARNINGS"
    puts
  end
end

def main(namespace)
  git_pull
  checkout_branch
  NamespaceChecker.new(namespace: namespace).run
end

def git_pull
  puts 'TODO git_pull...'
end

def checkout_branch
  puts 'TODO checkout_branch...'
end

main ARGV.shift
