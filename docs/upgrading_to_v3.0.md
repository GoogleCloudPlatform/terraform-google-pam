# Upgrading to v3.0.0

The v3.0 release contains backwards-incompatible changes.


### New variable entitlement_pending_notification_recipients for pending grant notification
Prior to v3.0 `entitlement_approval_notification_recipients` were notified of both grant approved and grant pending. Starting v3.0 `entitlement_approval_notification_recipients` will only be notified of grant approved. A new variable `entitlement_pending_notification_recipients` is added for list of additional email addresses to be notified when a grant is pending approval.
