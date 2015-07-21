# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
# \subsubsection{Under RHEL5}

class dod_login_warnings::gdm::rhel5 {
    include zenity
    include ::gdm::rhel5

    # This one is for zenity to show. zenity can word-wrap.
    file { "/etc/issue_paragraphs":
        owner => root, group => 0, mode => 0644,
        source => "puppet:///modules/\
dod_login_warnings/paragraphs",
    }

    exec { 'show_gdm_login_warning':
        command => "sed -i -e '/^exit 0$/i \
zenity --error --text \"`cat /etc/issue_paragraphs`\"
' /etc/gdm/Init/Default",
        unless => "grep 'zenity.*error.*issue.*' \
                   /etc/gdm/Init/Default",
        notify => Exec['restart_gdm'],
        require => Class['gdm::logo'],
    }
}
