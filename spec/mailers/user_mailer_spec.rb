require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "incident_created" do
    let(:team)            { create(:team) }
    let(:user)            { create(:user, teams: [team]) }
    let(:incident)        { create(:incident, team: team) }
    let(:calendar)        { team.calendar }
    let(:calendar_event)  { create(:calendar_event, calendar: calendar) }

    context 'incident events' do
      context '.incident_created' do
        let(:mail) {
          UserMailer.incident_created(user: user, incident: incident)
        }

        it "renders the headers" do
          expect(mail.subject).to eq("New incident was created")
          expect(mail.to).to eq([user.email])
          expect(mail.from).to eq(['CMP@localhost'])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match('New incident was created')
          expect(mail.body.encoded).to match(incident.title)
        end
      end

      context '.incident_acked' do
        let(:mail) {
          UserMailer.incident_acked(user: user, incident: incident)
        }

        it "renders the headers" do
          expect(mail.subject).to eq("Incident ##{incident.iid} was acknowledged")
          expect(mail.to).to eq([user.email])
          expect(mail.from).to eq(['CMP@localhost'])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match('acknowledged!')
          expect(mail.body.encoded).to match(incident.title)
        end
      end

      context '.incident_resolved' do
        let(:mail) {
          UserMailer.incident_resolved(user: user, incident: incident)
        }

        it "renders the headers" do
          expect(mail.subject).to eq("Incident ##{incident.iid} was resolved")
          expect(mail.to).to eq([user.email])
          expect(mail.from).to eq(['CMP@localhost'])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match('resolved!')
          expect(mail.body.encoded).to match(incident.title)
        end
      end

      context '.on_call_started' do
        let(:mail) {
          UserMailer.on_call_started(user: user, calendar_event: calendar_event)
        }

        it "renders the headers" do
          expect(mail.subject).to eq("Your on call shift just started")
          expect(mail.to).to eq([user.email])
          expect(mail.from).to eq(['CMP@localhost'])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match('You are on call now')
        end
      end

      context '.on_call_finished' do
        let(:mail) {
          UserMailer.on_call_finished(user: user, calendar_event: calendar_event)
        }

        it "renders the headers" do
          expect(mail.subject).to eq("Your on call shift just finished")
          expect(mail.to).to eq([user.email])
          expect(mail.from).to eq(['CMP@localhost'])
        end

        it "renders the body" do
          expect(mail.body.encoded).to match('You are not on call from now')
        end
      end
    end
  end
end
